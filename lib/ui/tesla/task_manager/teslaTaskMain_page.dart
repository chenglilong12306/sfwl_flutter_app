import 'package:flutter/material.dart';
import 'package:sfwl_flutter_app/common/widget/base_tabbar_widget.dart';

import '../../../utils/navigator_utils.dart';
import 'teslaTaskListMobileCar_page.dart';
import 'teslaTaskListPositive_page.dart';
import 'teslaTaskListReturnEmpty_page.dart';

/**
 * FileName 特斯拉项目管理--项目任务
 * @Author lilong.chen
 * @Date 2022/7/18 15:55
 */

class TeslaTaskMainPage extends StatefulWidget {
  TeslaTaskMainPage({Key? super.key});

  @override
  TeslaTaskMainPageState createState() => TeslaTaskMainPageState();
}

class TeslaTaskMainPageState extends State<TeslaTaskMainPage>
    with
        AutomaticKeepAliveClientMixin<TeslaTaskMainPage>,
        WidgetsBindingObserver {
  ///正向
  final GlobalKey<TeslaTaskListPositivePageState> positiveKey = new GlobalKey();

  ///返空
  final GlobalKey<TeslaTaskListReturnEmptyPageState> returnEmptyKey =
      new GlobalKey();

  ///车厢迁移
  final GlobalKey<TeslaTaskListMobileCarPageState> mobileCarKey =
      new GlobalKey();

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
      _renderTab("正向"),
      _renderTab("返空"),
      _renderTab("迁移"),
    ];

    return Scaffold(
      body: new BaseTabBarWidget(
        type: TabType.top,
        title: Row(children: [
          Expanded(
            flex: 4,
            child: Text(
              "项目任务",
            ),
          ),
          IconButton(
              onPressed: () {
                NavigatorUtils.gotoTeslaTaskHistoryListPage(context);
              },
              icon: Image.asset("images/ic_history.png"))
        ]),
        tabItems: tabs,
        tabViews: [
          new TeslaTaskListPositivePage(key: positiveKey),
          new TeslaTaskListReturnEmptyPage(key: returnEmptyKey),
          new TeslaTaskListMobileCarPage(key: mobileCarKey),
        ],
      ),
    );
  }
}
