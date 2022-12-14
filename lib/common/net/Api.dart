import 'package:flutter/foundation.dart';

class Api {
  static const baseUrl = kDebugMode ? 'https://appsvcx.sfwl.net/' : 'https://appsvcx.sfwl.net/';
  // static const baseUrl = kDebugMode ? 'http://10.10.10.90:8084/' : 'http://10.10.10.90:8084/';

  /// 获取token
  static const tokenUrl = 'api/token/getToken';
  /// 登录
  static const loginUrl = 'Api/Basic/Login/Sign';
  /// 获取菜单权限
  static const getMenusUrl = 'Api/Basic/Menu/getMenus';
  /// 获取运输任务列表
  static const getTslTransportTaskList = 'Api/TslTransportManager/TslTransportTask/getTslTransportTaskList';
  /// 获取运输任务列表--返空单
  static const getTslTransportTaskListReturnEmpty = 'Api/TslTransportManager/TslTransportTask/getTslTransportTaskListReturnEmpty';
  /// 获取运输任务历史列表
  static const getTslTransportTaskHistoryList = 'Api/TslTransportManager/TslTransportTask/getTslTransportTaskHistoryList';
  /// 获取延误类型
  static const getTslDelayTypeInfo = 'Api/TslTransportManager/TslTransportTask/getTslDelayTypeInfo';
  /// 获取特斯拉--最新位置类型接口
  static const getTslNewAddressTypeInfo = 'Api/TslTransportManager/TslTransportTask/getTslNewAddressTypeInfo';
  /// 设置装车单状态--正向
  static const setStartLoadState = 'Api/TslTransportManager/TslTransportTask/setStartLoadState';
  /// 设置装车单状态--返空
  static const setStartLoadStateReturnEmpty = 'Api/TslTransportManager/TslTransportTask/setStartLoadStateReturnEmpty';
  /// 获取特斯拉--车厢类型接口
  static const getTslVehicleTypeInfo = 'Api/TslTransportManager/TslTransportTask/getTslVehicleTypeInfo';
  /// 获取特斯拉--进/出（停车场/堆场）类型接口
  static const getTslInOutTypeInfo = 'Api/TslTransportManager/TslTransportTask/getTslInOutTypeInfo';
  /// 根据位置类型查询库区
  static const getTeslaCarTrackAreaInfoList = 'Api/TslTransportManager/TslTransportTask/getTeslaCarTrackAreaInfoList';
  /// 获取车辆信息列表
  static const getCarInfoList = 'Api/TslTransportManager/TslTransportTask/getCarInfoList';
  /// 根据车牌查询最新的跟踪记录
  static const getTeslaCarTrackByCarNumber = 'Api/TslTransportManager/TslTransportTask/getTeslaCarTrackByCarNumber';
  /// 车厢位置跟踪登记
  static const setTslTaskCarTrack = 'Api/TslTransportManager/TslTransportTask/setTslTaskCarTrack';
  /// 根据场地类型获取车厢库存数量
  static const getInventoryQueryListByLocationType = 'Api/TslTransportManager/TslTransportTask/getInventoryQueryListByLocationType';
  /// 查询库区库存情况
  static const getInventoryQueryListAreaDetails = 'Api/TslTransportManager/TslTransportTask/getInventoryQueryListAreaDetails';
  /// 查询车厢库存情况
  static const getInventoryQueryListCarDetails = 'Api/TslTransportManager/TslTransportTask/getInventoryQueryListCarDetails';
}

