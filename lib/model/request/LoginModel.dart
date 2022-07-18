/**
 * 登录model
 */
class LoginModel {
  late String UserName;
  late String UserPwd;


  LoginModel(this.UserName,this.UserPwd);

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
     'UserName': this.UserName,
     'UserPwd' :this.UserPwd,
  };

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(json['UserName'], json['UserPwd']);
  }


}
