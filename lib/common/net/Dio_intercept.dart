import 'package:dio/dio.dart';
import 'package:sfwl_flutter_app/common/utils/DataHelper.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 此处根据业务逻辑，自行判断处理
    if ('token' != '') {
      options.headers['token'] = 'token';
    }
    super.onRequest(options, handler);
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
    print("请求内容options:"+options.data.toString());
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _endTime = DateTime.now();
    final int duration = _endTime.difference(_startTime).inMilliseconds;
    print("返回内容response:"+DataHelper.decodeBase64(response.data.toString()));
    print('---Request End: 耗时 $duration 毫秒---');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('---Resuest Error: ${err.toString()}');
    super.onError(err, handler);
  }
}

