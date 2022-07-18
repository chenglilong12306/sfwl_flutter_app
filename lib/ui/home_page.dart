import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sfwl_flutter_app/common/widget/base_tabbar_widget.dart';
import 'desk_page.dart';
import 'my_page.dart';

/**
 * 主页
 * Created by lilong.chen
 * Date: 2022-07-13
 */
class HomePage extends StatefulWidget {

  static final String sName = "home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<DeskPageState> deskKey = new GlobalKey();
  final GlobalKey<MyPageState> myKey = new GlobalKey();

  _renderTab(icon, text) {
    return new Tab(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[icon, new Text(text)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      _renderTab(Icon(Icons.home), "工具台"),
      _renderTab(Icon(Icons.person), "我的"),
    ];

    return Scaffold(
      body: new BaseTabBarWidget(
        type: TabType.noTopBar,
        tabItems: tabs,
        tabViews: [
          new DeskPage(key: deskKey),
          new MyPage(key: myKey),
        ],
      ),
    );
  }
}
