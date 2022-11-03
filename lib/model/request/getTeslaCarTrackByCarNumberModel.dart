/**
 * 获取车牌查询最新的跟踪记录接口的model
 */
class getTeslaCarTrackByCarNumberModel {
  late String driverId;
  late String comId;
  late String car_id;

  getTeslaCarTrackByCarNumberModel(this.driverId, this.comId, this.car_id);

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
        'driverId': this.driverId,
        'comId': this.comId,
        'car_id': this.car_id,
      };

  factory getTeslaCarTrackByCarNumberModel.fromJson(Map<String, dynamic> json) {
    return getTeslaCarTrackByCarNumberModel(
      json['driverId'],
      json['comId'],
      json['car_id'],
    );
  }
}
