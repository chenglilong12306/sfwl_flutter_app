import 'dart:ffi';

/**
 * FileName 运输任务列表实体
 * @Author lilong.chen
 * @Date 2022/7/19 11:18
 */

class TslTransportTaskInfo {
  /**
   * 装车单ID
   */
  late String load_id;

  /**
   * 装车单创建时间
   */
  late num load_addtime;

  /**
   * 装车单运营公司
   */
  late String load_comid;

  /**
   * 装车单运营场站
   */
  late String load_subid;

  /**
   * 装车单号
   */
  late String load_sn;

  /**
   * 装车单--司机ID
   */
  late String load_Dirs;

  /**
   * 装车单--车牌号
   */
  late String load_carNumber;

  /**
   * 装车单--车牌号--车厢
   */
  late String load_carNumber_cx;

  /**
   * 装车单--封签
   */
  late String load_fengqian;

  /**
   * 装车单--集装箱号
   */
  late String sload_trailerNumber;

  /**
   * 装车单状态
   */
  late String load_state;

  /**
   * 装车单发车时间
   */
  late num load_sendTime;

  /**
   * 装车单备注
   */
  late String load_other;

  /**
   * 装车单--是否自车
   */
  late String load_isHaving;

  /**
   * 装车单--起运城市
   */
  late String load_beginCityName;

  /**
   * 装车单--终点城市
   */
  late String load_endCityName;

  /**
   * 跟踪ID
   */
  late String load_tracid;

  /**
   * 跟踪号
   */
  late String load_tracTnumber;

  /**
   * 跟踪类型
   */
  late String load_tracType;

  /**
   * 跟踪状态
   */
  late String load_tracState;

  /**
   * 跟踪来源
   */
  late String load_tracSource;

  /**
   * 跟踪明细状态
   */
  late String load_trdState;

  TslTransportTaskInfo(
      this.load_id,
      this.load_addtime,
      this.load_comid,
      this.load_subid,
      this.load_sn,
      this.load_Dirs,
      this.load_carNumber,
      this.load_carNumber_cx,
      this.load_fengqian,
      this.sload_trailerNumber,
      this.load_state,
      this.load_sendTime,
      this.load_other,
      this.load_isHaving,
      this.load_beginCityName,
      this.load_endCityName,
      this.load_tracid,
      this.load_tracTnumber,
      this.load_tracType,
      this.load_tracState,
      this.load_tracSource,
      this.load_trdState);

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
        'load_id': this.load_id,
        'load_addtime': this.load_addtime,
        'load_comid': this.load_comid,
        'load_subid': this.load_subid,
        'load_sn': this.load_sn,
        'load_Dirs': this.load_Dirs,
        'load_carNumber': this.load_carNumber,
        'load_carNumber_cx': this.load_carNumber_cx,
        'load_fengqian': this.load_fengqian,
        'sload_trailerNumber': this.sload_trailerNumber,
        'load_state': this.load_state,
        'load_sendTime': this.load_sendTime,
        'load_other': this.load_other,
        'load_isHaving': this.load_isHaving,
        'load_beginCityName': this.load_beginCityName,
        'load_endCityName': this.load_endCityName,
        'load_tracid': this.load_tracid,
        'load_tracTnumber': this.load_tracTnumber,
        'load_tracType': this.load_tracType,
        'load_tracState': this.load_tracState,
        'load_tracSource': this.load_tracSource,
        'load_trdState': this.load_trdState,
      };

  factory TslTransportTaskInfo.fromJson(Map<String, dynamic> jsonStr) {
    return TslTransportTaskInfo(
        jsonStr['load_id'],
        jsonStr['load_addtime'],
        jsonStr['load_comid'] != null ? jsonStr['load_comid'] : "",
        jsonStr['load_subid'] != null ? jsonStr['load_subid'] : "",
        jsonStr['load_sn'],
        jsonStr['load_Dirs'] != null ? jsonStr['load_Dirs'] : "",
        jsonStr['load_carNumber'],
        jsonStr['load_carNumber_cx'],
        jsonStr['load_fengqian'] != null ? jsonStr['load_fengqian'] : "",
        jsonStr['sload_trailerNumber'] != null
            ? jsonStr['sload_trailerNumber']
            : "",
        jsonStr['load_state'],
        jsonStr['load_sendTime'],
        jsonStr['load_other'] != null ? jsonStr['load_other'] : "",
        jsonStr['load_isHaving'] != null ? jsonStr['load_isHaving'] : "",
        jsonStr['load_beginCityName'] != null ? jsonStr['load_beginCityName'] : "",
        jsonStr['load_endCityName'] != null ? jsonStr['load_endCityName'] : "",
        jsonStr['load_tracid'] != null ? jsonStr['load_tracid'] : "",
        jsonStr['load_tracTnumber'] != null ? jsonStr['load_tracTnumber'] : "",
        jsonStr['load_tracType'] != null ? jsonStr['load_tracType'] : "",
        jsonStr['load_tracState'] != null ? jsonStr['load_tracState'] : "",
        jsonStr['load_tracSource'] != null ? jsonStr['load_tracSource'] : "",
        jsonStr['load_trdState'] != null ? jsonStr['load_trdState'] : "");
  }
}