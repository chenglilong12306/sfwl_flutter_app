/**
 * 获取菜单的model
 */
class GetMenuModel {
  late String userId;


  GetMenuModel(this.userId);

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
     'userId': this.userId,
  };

  factory GetMenuModel.fromJson(Map<String, dynamic> json) {
    return GetMenuModel(json['userId']);
  }


}
