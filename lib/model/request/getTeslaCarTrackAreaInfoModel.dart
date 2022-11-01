/**
 * 根据位置类型查询库区接口的model
 */
class getTeslaCarTrackAreaInfoModel {
  late String area_locationType;
  late String driverId;
  late String comId;

  getTeslaCarTrackAreaInfoModel(
      this.area_locationType, this.driverId, this.comId);

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
        'area_locationType': this.area_locationType,
        'driverId': this.driverId,
        'comId': this.comId,
      };

  factory getTeslaCarTrackAreaInfoModel.fromJson(Map<String, dynamic> json) {
    return getTeslaCarTrackAreaInfoModel(
        json['area_locationType'], json['driverId'], json['comId']);
  }
}
