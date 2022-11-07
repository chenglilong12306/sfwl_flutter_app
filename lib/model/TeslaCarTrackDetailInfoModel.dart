/**
 * FileName TeslaCarTrackInfoModel   特斯拉车厢跟踪明细表
 * @Author lilong.chen
 * @Date 2022/11/2 17:33
 */

class TeslaCarTrackDetailInfoModel {

  /**
   * ID
   */
  late String tctd_id;

  /**
   * 跟踪主表ID
   */
  late String tctd_teslactId;

  /**
   * 跟踪位置
   */
  late String tctd_trackLocation;

  /**
   * 跟踪人
   */
  late String tctd_trackUser;

  /**
   * 跟踪人ID
   */
  late String tctd_trackUserId;

  /**
   * 跟踪时间
   */
  late num tctd_trackTime;

  /**
   * 跟踪位置类型
   * 可选值：dc = 堆场；tcc = 停车场 ； kh = 客户
   */
  late String tctd_locationType;
  /**
   * 经度
   */
  late double tctd_trackLongitude;
  /**
   * 纬度
   */
  late double tctd_trackLatitude;
  /**
   * 操作动作
   */
  late int tctd_action;
  /**
   * 所在库区名称
   */
  late String tctd_stoAreaName;
  /**
   * 所在库区ID
   */
  late String tctd_stoAreaId;
  /**
   * 装车单号
   */
  late String tctd_loadSn;
  /**
   * 操作类型
   */
  late int tctd_lastestType;

  /**
   * 所在行
   */
  late int tctd_line;
  /**
   * 所在列
   */
  late int tctd_column;
  /**
   * 车厢类型：  kg：空柜  zg：重柜   fk：返空柜
   */
  late String tctd_vehicleType;
  /**
   * 集装箱号
   */
  late String car_trailerNumber;
  /**
   * 进出类型
   */
  late String tctd_inOutType;


  TeslaCarTrackDetailInfoModel(
      this.tctd_id
      ,this.tctd_teslactId
      ,this.tctd_trackLocation
      ,this.tctd_trackUser
      ,this.tctd_trackUserId
      ,this.tctd_trackTime
      ,this.tctd_locationType
      ,this.tctd_trackLongitude
      ,this.tctd_trackLatitude
      ,this.tctd_action
      ,this.tctd_stoAreaName
      ,this.tctd_stoAreaId
      ,this.tctd_loadSn
      ,this.tctd_lastestType
      ,this.tctd_line
      ,this.tctd_column
      ,this.tctd_vehicleType
      ,this.tctd_inOutType
      );


  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
    'tctd_id': this.tctd_id,
    'tctd_teslactId': this.tctd_teslactId,
    'tctd_trackLocation': this.tctd_trackLocation,
    'tctd_trackUser': this.tctd_trackUser,
    'tctd_trackUserId': this.tctd_trackUserId,
    'tctd_trackTime': this.tctd_trackTime,
    'tctd_locationType': this.tctd_locationType,
    'tctd_trackLongitude': this.tctd_trackLongitude,
    'tctd_trackLatitude': this.tctd_trackLatitude,
    'tctd_action': this.tctd_action,
    'tctd_stoAreaName': this.tctd_stoAreaName,
    'tctd_stoAreaId': this.tctd_stoAreaId,
    'tctd_loadSn': this.tctd_loadSn,
    'tctd_lastestType': this.tctd_lastestType,
    'tctd_line': this.tctd_line,
    'tctd_column': this.tctd_column,
    'tctd_vehicleType': this.tctd_vehicleType,
    'tctd_inOutType': this.tctd_inOutType,

  };


  factory TeslaCarTrackDetailInfoModel.fromJson(Map<String, dynamic> jsonStr) {
    return TeslaCarTrackDetailInfoModel(
      jsonStr['tctd_id'],
      jsonStr['tctd_teslactId'],
      jsonStr['tctd_trackLocation'],
      jsonStr['tctd_trackUser'],
      jsonStr['tctd_trackUserId'],
      jsonStr['tctd_trackTime'],
      jsonStr['tctd_locationType'],
      jsonStr['tctd_trackLongitude'],
      jsonStr['tctd_trackLatitude'],
      jsonStr['tctd_action'],
      jsonStr['tctd_stoAreaName'],
      jsonStr['tctd_stoAreaId'],
      jsonStr['tctd_loadSn'],
      jsonStr['tctd_lastestType'],
      jsonStr['tctd_line'],
      jsonStr['tctd_column'],
      jsonStr['tctd_vehicleType'],
      jsonStr['tctd_inOutType'],

    );
  }

}