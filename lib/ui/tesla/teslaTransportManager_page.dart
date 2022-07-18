import 'package:flutter/material.dart';
import 'package:sfwl_flutter_app/Constants.dart';
import 'package:sfwl_flutter_app/utils/navigator_utils.dart';

/**
 * FileName 特斯拉项目管理
 * @Author lilong.chen
 * @Date 2022/7/18 15:55
 */

class TeslaTransportManagerPage extends StatefulWidget{
  TeslaTransportManagerPage({Key? super.key});

  @override
  TeslaTransportManagerPageState createState() => TeslaTransportManagerPageState();
}

class TeslaTransportManagerPageState extends State<TeslaTransportManagerPage>
    with AutomaticKeepAliveClientMixin<TeslaTransportManagerPage>, WidgetsBindingObserver {

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


  /**
   * 项目任务
   */
  Widget transportTaskView() {
    return InkWell(
      onTap: () {
        NavigatorUtils.gotoTeslaTaskMainPage(context);
      },
      child: Container(
        //设置外边距
        margin: EdgeInsets.all(10),
        //设置内边距
        padding: EdgeInsets.all(10),
        //设置 child 居中
        alignment: Alignment(0, 0),
        //边框设置
        decoration: new BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          //设置四周边框
          border: new Border.all(width: 1, color: Colors.brown),
        ),
        child: Column(children: [
          Image.asset(
            "images/ico_task.png",
            width: double.tryParse(Constants.Image_icon_size_80),
          ),
          Text("项目任务"),
        ]),
      ),
    );
  }


  /**
   * 车厢管理
   */
  Widget carriageManagerView() {
    return InkWell(
      onTap: () {
        NavigatorUtils.gotoTeslaTaskCarriageMainPage(context);
      },
      child: Container(
        //设置外边距
        margin: EdgeInsets.all(10),
        //设置内边距
        padding: EdgeInsets.all(10),
        //设置 child 居中
        alignment: Alignment(0, 0),
        //边框设置
        decoration: new BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          //设置四周边框
          border: new Border.all(width: 1, color: Colors.brown),
        ),
        child: Column(children: [
          Image.asset(
            "images/ico_unload.png",
            width: double.tryParse(Constants.Image_icon_size_80),
          ),
          Text("车厢管理"),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.

    return Scaffold(
      appBar: AppBar(
        title: Text("特斯拉项目"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: [
              transportTaskView(),
              carriageManagerView(),
            ],
          )
        ],
      ),
    );
  }

}