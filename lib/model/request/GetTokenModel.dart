/**
 * 获取token的model
 */
class GetTokenModel {
  late String uid;
  late String pwd;


  GetTokenModel(this.uid,this.pwd);

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
     'uid': this.uid,
     'pwd' :this.pwd,
  };

  factory GetTokenModel.fromJson(Map<String, dynamic> json) {
    return GetTokenModel(json['uid'], json['pwd']);
  }


}
