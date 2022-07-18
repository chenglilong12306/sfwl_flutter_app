import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

///参数加密工具
class DataHelper {
  static encryptParams(Map<String, dynamic> map) {
    var buffer = StringBuffer();
    map.forEach((key, value) {
      buffer.write(key);
      buffer.write(value);
    });

    buffer.write("SERECT");
    var sign = string2MD5_16(buffer.toString());
    print("sign--->" + sign);
    return sign;
  }

  /**
   * 32 位的MD5加密
   */
  static string2MD5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  /**
   * 16 位的MD5加密
   */
  static string2MD5_16(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    var str = digest.toString().substring(8,24);
    return str;
  }

  ///Base64加密
  static String encodeBase64(String data){
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  ///Base64解密
  static String decodeBase64(String data){

    Uint8List base64deBody = base64Decode(data);
    String result = Utf8Decoder().convert(base64deBody);
    return result;
  }

}
