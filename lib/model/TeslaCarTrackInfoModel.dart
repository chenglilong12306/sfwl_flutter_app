/**
 * FileName TeslaCarTrackInfoModel   特斯拉车厢跟踪主表
 * @Author lilong.chen
 * @Date 2022/11/2 17:33
 */

class TeslaCarTrackInfo {

  /**
   * ID
   */
  late String teslact_id;
  /**
   * 车牌号码
   */
  late String teslact_carNumber;
  /**
   * 车牌唯一标识
   */
  late String teslact_carid;
  /**
   * 装车单号
   */
  late String teslact_loadSn;
  /**
   * 最新位置
   * 1、正向：到达堆场
   * 2、返空：离开堆场或停车场  ； 到达提货客户：xxxxx(客户名称)
   * 3、迁移：由堆场到停车场
   */
  late String teslact_latestLocation;
  /**
   * 最新位置类型
   * 可选值：dc = 堆场；tcc = 停车场；kh = 特斯拉客户
   */
  late String teslact_locationType;
  /**
   * 最新时间
   *
   * 操作的最后时间
   */
  late num teslact_latestTime;
  /**
   * 最新操作人姓名
   */
  late String teslact_latestUser;
  /**
   * 最新操作人ID
   */
  late String teslact_lastestUserId;
  /**
   * 最新经度
   */
  late double teslact_lastestLongitude;
  /**
   * 最新纬度
   */
  late double teslact_lastestLatitude;
  /**
   * 所在库区名称
   */
  late String teslact_stoAreaName;
  /**
   * 所在库区ID
   */
  late String teslact_stoAreaId;
  /**
   * 动作
   */
  late int teslact_action;
  /**
   * 操作类型
   */
  late int teslact_lastestType;
  /**
   * 所在行
   */
  late int teslact_line;
  /**
   * 所在列
   */
  late int teslact_column;
  /**
   * 车厢类型：  kg：空柜  zg：重柜
   */
  late String teslact_vehicleType;
  /**
   * 库区存储车厢总数
   */
  late int teslact_StoAreaSum;
  /**
   * 集装箱号
   */
  late String car_trailerNumber;
  /**
   * 进出类型
   */
  late String teslact_inOutType;

  TeslaCarTrackInfo(
      this.teslact_id
      ,this.teslact_carNumber
      ,this.teslact_carid
      ,this.teslact_loadSn
      ,this.teslact_latestLocation
      ,this.teslact_locationType
      ,this.teslact_latestTime
      ,this.teslact_latestUser
      ,this.teslact_lastestUserId
      ,this.teslact_lastestLongitude
      ,this.teslact_lastestLatitude
      ,this.teslact_stoAreaName
      ,this.teslact_stoAreaId
      ,this.teslact_action
      ,this.teslact_lastestType
      ,this.teslact_line
      ,this.teslact_column
      ,this.teslact_vehicleType
      ,this.teslact_StoAreaSum
      ,this.car_trailerNumber
      ,this.teslact_inOutType
      );


  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
    'teslact_id': this.teslact_id,
    'teslact_carNumber': this.teslact_carNumber,
    'teslact_carid': this.teslact_carid,
    'teslact_loadSn': this.teslact_loadSn,
    'teslact_latestLocation': this.teslact_latestLocation,
    'teslact_locationType': this.teslact_locationType,
    'teslact_latestTime': this.teslact_latestTime,
    'teslact_latestUser': this.teslact_latestUser,
    'teslact_lastestUserId': this.teslact_lastestUserId,
    'teslact_lastestLongitude': this.teslact_lastestLongitude,
    'teslact_lastestLatitude': this.teslact_lastestLatitude,
    'teslact_stoAreaName': this.teslact_stoAreaName,
    'teslact_stoAreaId': this.teslact_stoAreaId,
    'teslact_action': this.teslact_action,
    'teslact_lastestType': this.teslact_lastestType,
    'teslact_line': this.teslact_line,
    'teslact_column': this.teslact_column,
    'teslact_vehicleType': this.teslact_vehicleType,
    'teslact_StoAreaSum': this.teslact_StoAreaSum,
    'car_trailerNumber': this.car_trailerNumber,
    'teslact_inOutType': this.teslact_inOutType,
  };


  factory TeslaCarTrackInfo.fromJson(Map<String, dynamic> jsonStr) {
    return TeslaCarTrackInfo(
      jsonStr['teslact_id'],
      jsonStr['teslact_carNumber'],
      jsonStr['teslact_carid'],
      jsonStr['teslact_loadSn'] != null ? jsonStr['teslact_loadSn'] : "",
      jsonStr['teslact_latestLocation'] != null ? jsonStr['teslact_latestLocation'] : "",
      jsonStr['teslact_locationType'] != null ? jsonStr['teslact_locationType'] : "",
      jsonStr['teslact_latestTime'],
      jsonStr['teslact_latestUser'] != null ? jsonStr['teslact_latestUser'] : "",
      jsonStr['teslact_lastestUserId'] != null ? jsonStr['teslact_lastestUserId'] : "",
      jsonStr['teslact_lastestLongitude'],
      jsonStr['teslact_lastestLatitude'],
      jsonStr['teslact_stoAreaName'] != null ? jsonStr['teslact_stoAreaName'] : "",
      jsonStr['teslact_stoAreaId'] != null ? jsonStr['teslact_stoAreaId'] : "",
      jsonStr['teslact_action'] != null ? jsonStr['teslact_action'] : "",
      jsonStr['teslact_lastestType'] != null ? jsonStr['teslact_lastestType'] : "",
      jsonStr['teslact_line'],
      jsonStr['teslact_column'],
      jsonStr['teslact_vehicleType'] != null ? jsonStr['teslact_vehicleType'] : "",
      jsonStr['teslact_StoAreaSum'],
      jsonStr['car_trailerNumber'] != null ? jsonStr['car_trailerNumber'] : "",
      jsonStr['teslact_inOutType'] != null ? jsonStr['teslact_inOutType'] : "",
    );
  }

  /**
   * 初始化
   */
  factory TeslaCarTrackInfo.init() {
    return TeslaCarTrackInfo("", "", "", "", "", "", 0, "", "", 0, 0, "", "", 0, 0, 0, 0, "", 0, "", "");
  }

}