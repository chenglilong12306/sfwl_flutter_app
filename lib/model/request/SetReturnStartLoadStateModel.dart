/**
 * FileName 设置装车单状态--返空
 * @Author lilong.chen
 * @Date 2022/9/9 16:27
 */

class SetReturnStartLoadStateModel {

  late String driverId;
  late String comId;
  late String loadId;
  late String loadState;
  late String loadLon;
  late String loadLat;
  late String loadAddress;
  late String loadNewAddressTypeCode;

  SetReturnStartLoadStateModel(this.driverId,this.comId,this.loadId,this.loadState,this.loadLon,this.loadLat,this.loadAddress,this.loadNewAddressTypeCode);

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
    'driverId': this.driverId,
    'comId' :this.comId,
    'loadId' :this.loadId,
    'loadState' :this.loadState,
    'loadLon' :this.loadLon,
    'loadLat' :this.loadLat,
    'loadAddress' :this.loadAddress,
    'loadNewAddressTypeCode' :this.loadNewAddressTypeCode,
  };


  factory SetReturnStartLoadStateModel.fromJson(Map<String, dynamic> json) {
    return SetReturnStartLoadStateModel(
        json['driverId'],
        json['comId'],
        json['loadId'],
        json['loadState'],
        json['loadLon'],
        json['loadLat'],
        json['loadAddress'],
        json['loadNewAddressTypeCode']
    );
  }

}