/**
 * 查询库区库存情况接口的model
 */
class getInventoryQueryListAreaDetailsModel {
  late String driverId;
  late String comId;
  late String locationType;
  late String stoAreaId;

  getInventoryQueryListAreaDetailsModel(
      this.driverId, this.comId, this.locationType, this.stoAreaId);

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
        'driverId': this.driverId,
        'comId': this.comId,
        'locationType': this.locationType,
        'stoAreaId': this.stoAreaId,
      };

  factory getInventoryQueryListAreaDetailsModel.fromJson(
      Map<String, dynamic> json) {
    return getInventoryQueryListAreaDetailsModel(
      json['driverId'],
      json['comId'],
      json['locationType'],
      json['stoAreaId'],
    );
  }
}
