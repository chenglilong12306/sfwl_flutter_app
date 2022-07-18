import 'package:flutter/material.dart';
import 'package:sfwl_flutter_app/Constants.dart';
import 'package:sfwl_flutter_app/Global.dart';
import 'package:sfwl_flutter_app/common/db/provider/UserInfoDbProvider.dart';
import 'package:sfwl_flutter_app/model/UserInfoModel.dart';

/**
 * 我的tab页
 * Created by lilong.chen
 * Date: 2022-07-13
 */
class MyPage extends StatefulWidget {
  MyPage({Key? super.key});

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<MyPage>
    with AutomaticKeepAliveClientMixin<MyPage>, WidgetsBindingObserver {
  UserInfoDbProvider userInfoDbProvider = new UserInfoDbProvider();

  ///用户对象
  UserInfoModel? user = null;

  @override
  void initState() {
    _getUserinfoDate();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _getUserinfoDate() async {
    user = await userInfoDbProvider
        .getUserInfo(Global.spUtil.getString(Constants.USERID));
    setState(() {});
  }

  /**
   * 个人信息
   */
  Widget userInfoView() {
    return Container(
      margin: EdgeInsets.only(left: 5, top: 10, right: 5),
      //设置 child 居中
      alignment: Alignment(0, 0),
      //边框设置
      decoration: new BoxDecoration(
        //背景
        color: Colors.white,
      ),
      child: InkWell(
        /// InkWell 可以触发点击事件
        onTap: () {
          print("点击了用户");
        },
        child: Row(children: [
          Expanded(
            ///Expanded 按比例占据空间
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: CircleAvatar(
                backgroundColor: Colors.lightBlue,
                radius: 50,
                child: Image.asset(
                  "images/ic_headimg.png",
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: 100,
              //设置 child 左方向对对齐
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      user?.user_name != null ? user!.user_name : "名称",
                      textScaleFactor: 1.5,
                      style: TextStyle(
                        fontWeight: FontWeight.bold, //字体加粗
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      user?.user_subname != null ? user!.user_subname : "场站",
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      user?.user_type != null ? user!.user_type : "职位",
                    ),
                  ),
                ],
              ),
            ),
          ),
          Image.asset(
            "images/ic_go_struk.png",
            width: 30.0,
          )
        ]),
      ),
    );
  }

  /**
   * 账号与安全
   */
  Widget accountView() {
    return Container(
      margin: EdgeInsets.only(left: 5, top: 20, right: 5),
      //设置 child 居中
      alignment: Alignment(0, 0),
      height: 50,
      //边框设置
      decoration: new BoxDecoration(
        //背景
        color: Colors.white,
      ),
      child: InkWell(
        /// InkWell 可以触发点击事件
        onTap: () {
          print("点击了账号与安全");
        },
        child: Row(children: [
          Expanded(

              ///Expanded 按比例占据空间
              flex: 1,
              child: Image.asset(
                "images/ic_security.png",
                width: 30.0,
              )),
          Expanded(
            flex: 4,
            child: Text(
              "账号与安全",
            ),
          ),
          Image.asset(
            "images/ic_go_struk.png",
            width: 30.0,
          )
        ]),
      ),
    );
  }

  /**
   * 常用设置
   */
  Widget commonSettingsView() {
    return Container(
      margin: EdgeInsets.only(left: 5, top: 5, right: 5),
      //设置 child 居中
      alignment: Alignment(0, 0),
      height: 50,
      //边框设置
      decoration: new BoxDecoration(
        //背景
        color: Colors.white,
      ),
      child: InkWell(
        /// InkWell 可以触发点击事件
        onTap: () {
          print("点击了常用设置");
        },
        child: Row(children: [
          Expanded(

            ///Expanded 按比例占据空间
              flex: 1,
              child: Image.asset(
                "images/ic_config.png",
                width: 30.0,
              )),
          Expanded(
            flex: 4,
            child: Text(
              "常用设置",
            ),
          ),
          Image.asset(
            "images/ic_go_struk.png",
            width: 30.0,
          )
        ]),
      ),
    );
  }

  /**
   * 帮助与反馈
   */
  Widget otherView() {
    return Container(
      margin: EdgeInsets.only(left: 5, top: 20, right: 5),
      //设置 child 居中
      alignment: Alignment(0, 0),
      height: 50,
      //边框设置
      decoration: new BoxDecoration(
        //背景
        color: Colors.white,
      ),
      child: InkWell(
        /// InkWell 可以触发点击事件
        onTap: () {
          print("点击了帮助与反馈");
        },
        child: Row(children: [
          Expanded(

            ///Expanded 按比例占据空间
              flex: 1,
              child: Image.asset(
                "images/ic_help.png",
                width: 30.0,
              )),
          Expanded(
            flex: 4,
            child: Text(
              "帮助与反馈",
            ),
          ),
          Image.asset(
            "images/ic_go_struk.png",
            width: 30.0,
          )
        ]),
      ),
    );
  }

  /**
   * 关于盛丰助手
   */
  Widget aboutView() {
    return Container(
      margin: EdgeInsets.only(left: 5, top: 5, right: 5),
      //设置 child 居中
      alignment: Alignment(0, 0),
      height: 50,
      //边框设置
      decoration: new BoxDecoration(
        //背景
        color: Colors.white,
      ),
      child: InkWell(
        /// InkWell 可以触发点击事件
        onTap: () {
          print("点击了关于盛丰助手");
        },
        child: Row(children: [
          Expanded(

            ///Expanded 按比例占据空间
              flex: 1,
              child: Image.asset(
                "images/ic_about.png",
                width: 30.0,
              )),
          Expanded(
            flex: 4,
            child: Text(
              "关于盛丰助手",
            ),
          ),
          Image.asset(
            "images/ic_go_struk.png",
            width: 30.0,
          )
        ]),
      ),
    );
  }

  /**
   * 分享安装
   */
  Widget shareView() {
    return Container(
      margin: EdgeInsets.only(left: 5, top: 5, right: 5),
      //设置 child 居中
      alignment: Alignment(0, 0),
      height: 50,
      //边框设置
      decoration: new BoxDecoration(
        //背景
        color: Colors.white,
      ),
      child: InkWell(
        /// InkWell 可以触发点击事件
        onTap: () {
          print("点击了分享安装");
        },
        child: Row(children: [
          Expanded(

            ///Expanded 按比例占据空间
              flex: 1,
              child: Image.asset(
                "images/ic_share.png",
                width: 30.0,
              )),
          Expanded(
            flex: 4,
            child: Text(
              "分享安装",
            ),
          ),
          Image.asset(
            "images/ic_go_struk.png",
            width: 30.0,
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.

    return Scaffold(
      appBar: AppBar(
        title: Text("我的"),
        automaticallyImplyLeading: false,

        ///隐藏返回按钮
      ),
      body: Column(
        children: <Widget>[
          userInfoView(),
          accountView(),
          commonSettingsView(),
          otherView(),
          aboutView(),
          shareView(),
        ],
      ),
    );
  }
}
