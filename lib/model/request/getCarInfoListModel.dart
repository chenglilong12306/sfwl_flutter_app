/**
 * 获取车辆信息列表接口的model
 */
class getCarInfoListModel {
  late String driverId;
  late String comId;
  late String car_number;

  getCarInfoListModel(this.driverId, this.comId, this.car_number);

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
        'driverId': this.driverId,
        'comId': this.comId,
        'car_number': this.car_number,
      };

  factory getCarInfoListModel.fromJson(Map<String, dynamic> json) {
    return getCarInfoListModel(
      json['driverId'],
      json['comId'],
      json['car_number'],
    );
  }
}
