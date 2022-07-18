import 'package:flutter/material.dart';
import 'package:sfwl_flutter_app/Constants.dart';
import 'package:sfwl_flutter_app/Global.dart';
import 'package:sfwl_flutter_app/common/db/provider/AppMenuDbProvider.dart';
import 'package:sfwl_flutter_app/model/AppMenuModel.dart';

/**
 * 工作台tab页
 * Created by lilong.chen
 * Date: 2022-07-13
 */
class DeskPage extends StatefulWidget {
  DeskPage({Key? super.key});

  @override
  DeskPageState createState() => DeskPageState();
}

class DeskPageState extends State<DeskPage>
    with AutomaticKeepAliveClientMixin<DeskPage>, WidgetsBindingObserver {
  AppMenuDbProvider appMenuDbProvider = new AppMenuDbProvider();
  List<AppMenuModel> appMenuModelList = <AppMenuModel>[];
  List<AppMenuModel> baseMenuLists = <AppMenuModel>[];

  ///基础菜单
  List<AppMenuModel> expandMenuLists = <AppMenuModel>[];

  ///扩展菜单

  @override
  void initState() {
    _getMenuData();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /**
   * 获取菜单数据
   */
  void _getMenuData() async {
    appMenuModelList = await appMenuDbProvider
        .getAppMenuInfoByUserId(Global.spUtil.getString(Constants.USERID));
    baseMenuLists = [];
    expandMenuLists = [];
    for (AppMenuModel menu in appMenuModelList) {
      if (0 == menu.menu_type) {
        ///基础菜单
        baseMenuLists.add(menu);
      } else if (1 == menu.menu_type) {
        ///扩展菜单
        expandMenuLists.add(menu);
      }
    }
    print("数据获取完成" + appMenuModelList.length.toString());
    setState(() {
      // _getMenuViewData();
    });
  }

  Widget menuView(AppMenuModel item) {
    return InkWell(
      onTap: () {
        print(item.menu_name);
      },
      child: Container(
        //设置外边距
        margin: EdgeInsets.only(left: 5, top: 10, right: 5),
        //设置内边距
        padding: EdgeInsets.only(top: 10),
        //设置 child 居中
        alignment: Alignment(0, 0),
        //边框设置
        decoration: new BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          //设置四周边框
          border: new Border.all(width: 1, color: Colors.cyan),
        ),
        child: Column(children: [
          Image(
            image: NetworkImage(item.menu_ico),
            width: 50.0,
            height: 50.0,
          ),
          Text(item.menu_name),
        ]),
      ),
    );
  }

  /**
   * 获取菜单UI
   */
  List<Widget> _getMenuViewData() {
    ///调用获取菜单数据方法
    List<Widget> list = [];
    print("开始渲染数据" + list.length.toString());
    for (AppMenuModel item in baseMenuLists) {
      if (item.menu_action != "OH") {
        list.add(menuView(item));
      }
    }
    for (AppMenuModel item in expandMenuLists) {
      if (item.menu_action != "OH") {
        list.add(menuView(item));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.

    return Scaffold(
      appBar: AppBar(
        title: Text("工作台"),

        ///隐藏返回按钮
        automaticallyImplyLeading: false,
      ),
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.0),
        children: this._getMenuViewData(),
      ),
    );
  }
}
