/**
 * FileName TokenModel
 * @Author lilong.chen
 * @Date 2022/7/20 11:04
 */

class TokenModel{

  late String key;
  late String token;


  TokenModel(this.key,this.token);


  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
    'key': this.key,
    'token' :this.token,
  };


  factory TokenModel.fromJson(Map<String, dynamic> jsonStr) {
    return TokenModel(
        jsonStr['key'],
        jsonStr['token'],
    );
  }


}