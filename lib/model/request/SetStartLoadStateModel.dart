/**
 * FileName 设置装车单状态--正向
 * @Author lilong.chen
 * @Date 2022/9/9 16:27
 */

class SetStartLoadStateModel {

  late String driverId;
  late String comId;
  late String loadId;
  late String loadState;
  late String loadLon;
  late String loadLat;
  late String loadAddress;
  late String loadTypeCode;
  late String loadNewAddressTypeCode;

  SetStartLoadStateModel(this.driverId,this.comId,this.loadId,this.loadState,this.loadLon,this.loadLat,this.loadAddress,this.loadTypeCode,this.loadNewAddressTypeCode);

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
    'driverId': this.driverId,
    'comId' :this.comId,
    'loadId' :this.loadId,
    'loadState' :this.loadState,
    'loadLon' :this.loadLon,
    'loadLat' :this.loadLat,
    'loadAddress' :this.loadAddress,
    'loadTypeCode' :this.loadTypeCode,
    'loadNewAddressTypeCode' :this.loadNewAddressTypeCode,
  };


  factory SetStartLoadStateModel.fromJson(Map<String, dynamic> json) {
    return SetStartLoadStateModel(
        json['driverId'],
        json['comId'],
        json['loadId'],
        json['loadState'],
        json['loadLon'],
        json['loadLat'],
        json['loadAddress'],
        json['loadTypeCode'],
        json['loadNewAddressTypeCode']
    );
  }

}