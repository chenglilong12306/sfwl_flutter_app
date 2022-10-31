/**
 * 获取特斯拉--进/出（停车场/堆场）类型接口的model
 */
class getTslInOutTypeInfoModel {
  late String action;


  getTslInOutTypeInfoModel(this.action);

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
     'action': this.action,
  };

  factory getTslInOutTypeInfoModel.fromJson(Map<String, dynamic> json) {
    return getTslInOutTypeInfoModel(json['action']);
  }


}
