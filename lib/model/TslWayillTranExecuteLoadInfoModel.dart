/**
 * FileName TslWayillTranExecuteLoadInfoModel  特斯拉运输--托单、执行、装车单查询返回类
 * @Author lilong.chen
 * @Date 2022/10/24 16:21
 */

class TslWayillTranExecuteLoadInfoModel {
  /**
   * 托单ID
   */
  late String way_id;

  /**
   * 印刷号
   */
  late String way_print_sn;

  /**
   * 客户订单号
   */
  late String way_cli_sn;

  /**
   * 收货客户订单号
   */
  late String way_arrive_sn;

  /**
   * 运营公司ID
   */
  late String way_comid;

  /**
   * 运营场站ID
   */
  late String way_subId;

  /**
   * 是否托单
   */
  late String way_isWay;

  /**
   * 执行ID
   */
  late String exe_id;

  /**
   * 执行公司ID
   */
  late String exe_comid;

  /**
   * 执行场站ID
   */
  late String exe_subid;

  /**
   * 执行类型
   */
  late String exe_type;

  /**
   * 直送类型
   */
  late String exe_isChange;

  /**
   * 是否拆单
   */
  late String exe_isSplit;

  /**
   * 装车单ID
   */
  late String exe_loadid;

  /**
   * 任务ID
   */
  late String tas_id;

  /**
   * 运营公司
   */
  late String tas_comid;

  /**
   * 运营场站
   */
  late String tas_subid;

  /**
   * 任务初始时间(除订单外，其他为进入场站时间;)
   */
  late num tas_StationTime;

  /**
   * 入库类型编码
   */
  late String tas_type;

  /**
   * 是拆单
   */
  late String tas_isSplit;

  /**
   * 关联装车单号
   */
  late String tas_loadid;

  /**
   * 是否最后(最新)数据
   */
  late String tas_isLastData;

  TslWayillTranExecuteLoadInfoModel(
      this.way_id,
      this.way_print_sn,
      this.way_cli_sn,
      this.way_arrive_sn,
      this.way_comid,
      this.way_subId,
      this.way_isWay,
      this.exe_id,
      this.exe_comid,
      this.exe_subid,
      this.exe_type,
      this.exe_isChange,
      this.exe_isSplit,
      this.exe_loadid,
      this.tas_id,
      this.tas_comid,
      this.tas_subid,
      this.tas_StationTime,
      this.tas_type,
      this.tas_isSplit,
      this.tas_loadid,
      this.tas_isLastData);

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
        'way_id': this.way_id,
        'way_print_sn': this.way_print_sn,
        'way_cli_sn': this.way_cli_sn,
        'way_arrive_sn': this.way_arrive_sn,
        'way_comid': this.way_comid,
        'way_subId': this.way_subId,
        'way_isWay': this.way_isWay,
        'exe_id': this.exe_id,
        'exe_comid': this.exe_comid,
        'exe_subid': this.exe_subid,
        'way_isWay': this.way_isWay,
        'exe_type': this.exe_type,
        'exe_isChange': this.exe_isChange,
        'exe_isSplit': this.exe_isSplit,
        'exe_loadid': this.exe_loadid,
        'tas_id': this.tas_id,
        'tas_comid': this.tas_comid,
        'tas_subid': this.tas_subid,
        'tas_StationTime': this.tas_StationTime,
        'tas_type': this.tas_type,
        'tas_isSplit': this.tas_isSplit,
        'tas_loadid': this.tas_loadid,
        'tas_isLastData': this.tas_isLastData,
      };

  factory TslWayillTranExecuteLoadInfoModel.fromJson(
      Map<String, dynamic> jsonStr) {
    return TslWayillTranExecuteLoadInfoModel(
        jsonStr['way_id'],
        jsonStr['way_print_sn'] != null ? jsonStr['way_print_sn'] : "",
        jsonStr['way_cli_sn'] != null ? jsonStr['way_cli_sn'] : "",
        jsonStr['way_arrive_sn'] != null ? jsonStr['way_arrive_sn'] : "",
        jsonStr['way_comid'] != null ? jsonStr['way_comid'] : "",
        jsonStr['way_subId'] != null ? jsonStr['way_subId'] : "",
        jsonStr['way_isWay'] != null ? jsonStr['way_isWay'] : "",
        jsonStr['exe_id'] != null ? jsonStr['exe_id'] : "",
        jsonStr['exe_comid'] != null ? jsonStr['exe_comid'] : "",
        jsonStr['exe_subid'] != null ? jsonStr['exe_subid'] : "",
        jsonStr['exe_type'] != null ? jsonStr['exe_type'] : "",
        jsonStr['exe_isChange'] != null ? jsonStr['exe_isChange'] : "",
        jsonStr['exe_isSplit'] != null ? jsonStr['exe_isSplit'] : "",
        jsonStr['exe_loadid'] != null ? jsonStr['exe_loadid'] : "",
        jsonStr['tas_id'] != null ? jsonStr['tas_id'] : "",
        jsonStr['tas_comid'] != null ? jsonStr['tas_comid'] : "",
        jsonStr['tas_subid'] != null ? jsonStr['tas_subid'] : "",
        jsonStr['tas_StationTime'] != null ? jsonStr['tas_StationTime'] : 0,
        jsonStr['tas_type'] != null ? jsonStr['tas_type'] : "",
        jsonStr['tas_isSplit'] != null ? jsonStr['tas_isSplit'] : "",
        jsonStr['tas_loadid'] != null ? jsonStr['tas_loadid'] : "",
        jsonStr['tas_isLastData'] != null ? jsonStr['tas_isLastData'] : "");
  }
}
