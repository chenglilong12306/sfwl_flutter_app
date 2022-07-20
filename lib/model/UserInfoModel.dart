
/**
 * 用户信息model
 */
class UserInfoModel {

  late String user_app_pwd;
  late String user_cityname;
  late String user_comid;
  late String user_comname;
  late String user_id;
  late bool user_isBingdingPhone;
  late String user_name;
  late String user_pwd;
  late String user_subid;
  late String user_subname;
  late String user_type;
  late String user_uid;

  // UserInfoModel();

  UserInfoModel(this.user_app_pwd,this.user_cityname,this.user_comid,
      this.user_comname,this.user_id,this.user_isBingdingPhone,this.user_name,
      this.user_pwd,this.user_subid,this.user_subname,this.user_type,this.user_uid);

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
    'user_app_pwd': this.user_app_pwd,
    'user_cityname' :this.user_cityname,
    'user_comid' :this.user_comid,
    'user_comname' :this.user_comname,
    'user_id' :this.user_id,
    'user_isBingdingPhone' :this.user_isBingdingPhone,
    'user_name' :this.user_name,
    'user_pwd' :this.user_pwd,
    'user_subid' :this.user_subid,
    'user_subname' :this.user_subname,
    'user_type' :this.user_type,
    'user_uid' :this.user_uid,
  };

  factory UserInfoModel.fromJson(Map<String, dynamic> jsonStr) {
    return UserInfoModel(
        jsonStr['user_app_pwd'],
        jsonStr['user_cityname'],
        jsonStr['user_comid'],
        jsonStr['user_comname'],
        jsonStr['user_id'],
        jsonStr['user_isBingdingPhone'],
        jsonStr['user_name'],
        jsonStr['user_pwd'],
        jsonStr['user_subid'],
        jsonStr['user_subname'],
        jsonStr['user_type'],
        jsonStr['user_uid']
    );
  }

}