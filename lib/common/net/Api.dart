import 'package:flutter/foundation.dart';

class Api {
  static const baseUrl = kDebugMode ? 'http://10.10.10.90:8084/' : 'http://10.10.10.90:8084/';

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
}

