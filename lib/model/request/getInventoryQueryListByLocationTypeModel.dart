/**
 * 根据场地类型获取车厢库存数量接口的model
 */
class getInventoryQueryListByLocationTypeModel {
  late String locationType;
  late String driverId;
  late String comId;

  getInventoryQueryListByLocationTypeModel(
      this.locationType, this.driverId, this.comId);

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
        'locationType': this.locationType,
        'driverId': this.driverId,
        'comId': this.comId,
      };

  factory getInventoryQueryListByLocationTypeModel.fromJson(Map<String, dynamic> json) {
    return getInventoryQueryListByLocationTypeModel(
        json['locationType'], json['driverId'], json['comId']);
  }
}
