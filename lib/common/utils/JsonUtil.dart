import 'package:sfwl_flutter_app/common/utils/DataHelper.dart';
import 'package:sfwl_flutter_app/common/utils/DateTimeUitl.dart';
import 'package:sfwl_flutter_app/common/utils/JSONObject.dart';


/**
 * Json工具类
 */
class JsonUtil{
  static final String KEY = "APRIL2017@SFWL@_2Z\$RXJ";

  /**
   * 组装POST提交的数据
   * 加入签名
   */
  static JSONObject setPostRequestParams(dynamic content,String userkey){

    int timeSpan =  DateTimeUtil.currentTimeMillis();
    String jsonContent = DataHelper.encodeBase64(content.toString());
    String jsonSign = DataHelper.string2MD5_16(DataHelper.string2MD5_16(content.toString() + KEY + timeSpan.toString()));
    return new JSONObject(userkey, jsonContent, timeSpan.toString(), jsonSign, "JSON");

  }

}