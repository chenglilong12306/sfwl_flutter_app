import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:sfwl_flutter_app/Constants.dart';
import 'package:sfwl_flutter_app/Global.dart';
import 'package:sfwl_flutter_app/common/net/Api.dart';
import 'package:sfwl_flutter_app/common/net/Dio_utils.dart';
import 'package:sfwl_flutter_app/common/utils/DataHelper.dart';
import 'package:sfwl_flutter_app/common/utils/DateTimeUitl.dart';
import 'package:sfwl_flutter_app/common/utils/JsonUtil.dart';
import 'package:sfwl_flutter_app/model/TokenModel.dart';
import 'package:sfwl_flutter_app/model/request/GetTokenModel.dart';

class AuthInterceptor extends Interceptor {
  Dio _dio;

  AuthInterceptor(this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 此处根据业务逻辑，自行判断处理
    var token = Global.spUtil.getString(Constants.TOKEN).toString();
    var key = Global.spUtil.getString(Constants.KEY).toString();
    int timeSpan =  DateTimeUtil.currentTimeMillis();
    String md5Token =DataHelper.string2MD5_16(token.toString() + "." + timeSpan.toString());
    if (token != '') {
      options.headers['Authorization'] = key + "_" + md5Token + "_" + timeSpan.toString();
    }
    // getToken();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {

    // TODO 发送刷新Token请求
    super.onResponse(response, handler);
  }

  Future<String> getToken() async {
    String Atoken = Global.spUtil.getString("Atoken").toString(); //获取当前的Atoken
    TokenModel tokenModel = new TokenModel("","");
    _dio.options.headers['refresh-token'] = Atoken;//设置当前的refreshToken

    try {
      String url = Api.baseUrl+Api.tokenUrl; //refreshToken url
      GetTokenModel getTokenModel = new GetTokenModel(Global.spUtil.get(Constants.USERUID).toString(), Global.spUtil.get(Constants.USERPWD).toString());
      dynamic params = JsonUtil.setPostRequestParams(json.encode(getTokenModel.toJson()), Global.spUtil.get(Constants.USERID).toString()).toJsonV3();
      var response = await HttpUtils.instance.post(url, params:params); //请求refreshToken刷新的接口
      // print(response.toString());
      ///将服务器返回的内容转成model
      tokenModel = TokenModel.fromJson(response.data);
      Global.spUtil.setString(Constants.KEY, tokenModel.key);
      Global.spUtil.setString(Constants.TOKEN, tokenModel.token);
    } on DioError catch (e) {
      if(e.response==401){ //401代表refresh_token过期

      }
    }
    return tokenModel.token;
  }
}

class LogInterceptor extends Interceptor {
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _startTime = DateTime.now();
    // 此处根据业务逻辑，自行增加 requestUrl requestMethod headers queryParameters 等参数的打印
    print('---Request Start---');
    print("请求内容options:" + options.data.toString());
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _endTime = DateTime.now();
    final int duration = _endTime.difference(_startTime).inMilliseconds;
    print("返回内容response:" + DataHelper.decodeBase64(response.data.toString()));
    print('---Request End: 耗时 $duration 毫秒---');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('---Resuest Error: ${err.toString()}');
    super.onError(err, handler);
  }
}
