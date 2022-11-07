/**
 * 查询车厢库存情况接口的model
 */
class getInventoryQueryListCarDetailsModel {
  late String car_id;
  late String driverId;
  late String comId;

  getInventoryQueryListCarDetailsModel(
      this.car_id, this.driverId, this.comId);

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
        'car_id': this.car_id,
        'driverId': this.driverId,
        'comId': this.comId,
      };

  factory getInventoryQueryListCarDetailsModel.fromJson(Map<String, dynamic> json) {
    return getInventoryQueryListCarDetailsModel(
        json['car_id'], json['driverId'], json['comId']);
  }
}
