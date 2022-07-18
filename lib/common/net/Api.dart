import 'package:flutter/foundation.dart';

class Api {
  static const baseUrl = kDebugMode ? 'http://10.10.10.90:8084/' : 'http://10.10.10.90:8084/';

  /// 登录
  static const loginUrl = 'Api/Basic/Login/Sign';
  /// 获取菜单权限
  static const getMenusUrl = 'Api/Basic/Menu/getMenus';
}

