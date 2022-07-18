
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/**
 * 全局缓存变量类
 */
class Global {
  static late SharedPreferences spUtil;

  static Future init() async{
    WidgetsFlutterBinding.ensureInitialized();
    spUtil = await SharedPreferences.getInstance();
  }

}