import 'package:flutter/material.dart';

import '../../../common/widget/base_tabbar_widget.dart';
import 'teslaTaskCarriageManager_page.dart';
import 'teslaTaskInventoryQuery_page.dart';

/**
 * FileName 特斯拉项目管理--车厢管理
 * @Author lilong.chen
 * @Date 2022/7/18 15:55
 */

class TeslaTaskCarriageMainPage extends StatefulWidget{
  TeslaTaskCarriageMainPage({Key? super.key});

  @override
  TeslaTaskCarriageMainPageState createState() => TeslaTaskCarriageMainPageState();
}

class TeslaTaskCarriageMainPageState extends State<TeslaTaskCarriageMainPage>
    with AutomaticKeepAliveClientMixin<TeslaTaskCarriageMainPage>, WidgetsBindingObserver {

  ///车厢管理
  final GlobalKey<TeslaTaskCarriageManagerPageState> carriageManagerKey = new GlobalKey();

  ///库存查询
  final GlobalKey<TeslaTaskInventoryQueryPageState> inventoryQueryKey = new GlobalKey();


  _renderTab(text) {
    return new Tab(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[new Text(text)],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      _renderTab("车厢管理"),
      _renderTab("库存查询"),
    ];

    return Scaffold(
      body: new BaseTabBarWidget(
        type: TabType.top,
        title: Row(children: [
          Expanded(
            flex: 4,
            child: Text(
              "车厢管理",
            ),
          ),
        ]),
        tabItems: tabs,
        tabViews: [
          new TeslaTaskCarriageManagerPage(key: carriageManagerKey),
          new TeslaTaskInventoryQueryPage(key: inventoryQueryKey),
        ],
      ),
    );
  }

}