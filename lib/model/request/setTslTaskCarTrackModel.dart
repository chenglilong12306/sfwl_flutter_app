/**
 * 车厢所在库区的model
 */
class setTslTaskCarTrackModel {
  late String driverId;
  late String comId;
  late String car_number;
  late String car_id;
  late String loadLon;
  late String loadLat;
  late String loadAddress;
  late String loadNewAddressTypeCode;
  late String stoAreaName;
  late String stoAreaId;
  late int action;
  late int line;
  late int column;
  late String vehicleType;
  late String inOutType;

  setTslTaskCarTrackModel(
    this.driverId,
    this.comId,
    this.car_number,
    this.car_id,
    this.loadLon,
    this.loadLat,
    this.loadAddress,
    this.loadNewAddressTypeCode,
    this.stoAreaName,
    this.stoAreaId,
    this.action,
    this.line,
    this.column,
    this.vehicleType,
    this.inOutType,
  );

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
        'driverId': this.driverId,
        'comId': this.comId,
        'car_number': this.car_number,
        'car_id': this.car_id,
        'loadLon': this.loadLon,
        'loadLat': this.loadLat,
        'loadAddress': this.loadAddress,
        'loadNewAddressTypeCode': this.loadNewAddressTypeCode,
        'stoAreaName': this.stoAreaName,
        'stoAreaId': this.stoAreaId,
        'action': this.action,
        'line': this.line,
        'column': this.column,
        'vehicleType': this.vehicleType,
        'inOutType': this.inOutType,
      };

  factory setTslTaskCarTrackModel.fromJson(Map<String, dynamic> json) {
    return setTslTaskCarTrackModel(
      json['driverId'],
      json['comId'],
      json['car_number'],
      json['car_id'],
      json['loadLon'],
      json['loadLat'],
      json['loadAddress'],
      json['loadNewAddressTypeCode'],
      json['stoAreaName'],
      json['stoAreaId'],
      json['action'],
      json['line'],
      json['column'],
      json['vehicleType'],
      json['inOutType'],
    );
  }
}
