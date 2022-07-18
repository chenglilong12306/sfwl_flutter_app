
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sfwl_flutter_app/common/widget/never_overscroll_indicator.dart';
import 'package:sfwl_flutter_app/ui/home_page.dart';

/**
 * 导航工具类
 * Created by lilong.chen
 * Date: 2022-07-13
 */
class NavigatorUtils {

  ///替换
  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  ///跳转首页
  static gotoHomePage(BuildContext context) {
    NavigatorRouter(context, HomePage());
  }

  ///公共打开方式
  static NavigatorRouter(BuildContext context, Widget widget) {
    return Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (context) => pageContainer(widget, context)));
  }

  ///Page页面的容器，做一次通用自定义
  static Widget pageContainer(widget, BuildContext context) {
    return MediaQuery(

      ///不受系统字体缩放影响
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: NeverOverScrollIndicator(
          needOverload: false,
          child: widget,
        ));
  }

}