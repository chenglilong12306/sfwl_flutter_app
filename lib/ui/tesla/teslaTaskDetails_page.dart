import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sfwl_flutter_app/Constants.dart';
import 'package:sfwl_flutter_app/Global.dart';
import 'package:sfwl_flutter_app/common/net/Api.dart';
import 'package:sfwl_flutter_app/common/net/Dio_utils.dart';
import 'package:sfwl_flutter_app/common/utils/JsonUtil.dart';
import 'package:sfwl_flutter_app/model/TslTransportTaskInfoModel.dart';
import 'package:sfwl_flutter_app/model/TslTypeModel.dart';
import 'package:sfwl_flutter_app/model/request/getTslTransportTaskListModel.dart';
import 'package:sfwl_flutter_app/utils/LocationUtil.dart';


/**
 * FileName 特斯拉正向任务详情页面
 * @Author lilong.chen
 * @Date 2022/9/7 14:36
 */

class TeslaTaskDetailsPage extends StatefulWidget {
  final TslTransportTaskInfo info;

  TeslaTaskDetailsPage(this.info, {Key? super.key});

  @override
  TeslaTaskDetailsPageState createState() => TeslaTaskDetailsPageState(info);
}

class TeslaTaskDetailsPageState extends State<TeslaTaskDetailsPage>
    with
        AutomaticKeepAliveClientMixin<TeslaTaskDetailsPage>,
        WidgetsBindingObserver {
  final TslTransportTaskInfo info;
  var selectItemValue;
  List<TslTypeModel> typeModelList = <TslTypeModel>[];
  String _location = '';

  LocationUtil location = LocationUtil();



  TeslaTaskDetailsPageState(this.info);



  @override
  void initState() {
    getTslDelayTypeInfo();
    super.initState();

    location.getCurrentLocation((Map result){
      print('接收到result:$result');
      _location = result["address"];
    }).catchError((err){
      Fluttertoast.showToast(msg: err);
    });

  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void getTslDelayTypeInfo() async {
    ///获取延误类型
    getTslTransportTaskListModel gettaskInfo;
    gettaskInfo = new getTslTransportTaskListModel(
        Global.spUtil.getString(Constants.USERID).toString(),
        Global.spUtil.getString(Constants.USERCOMID).toString());
    final res = await HttpUtils.instance.post(
      Api.getTslDelayTypeInfo,
      params: JsonUtil.setPostRequestParams(json.encode(gettaskInfo.toJson()),
              Global.spUtil.getString(Constants.USERID).toString())
          .toJson(),
      tips: true,
    );
    for (var item in res.data) {
      TslTypeModel tslTypeModel = TslTypeModel.fromJson(item);
      typeModelList.add(tslTypeModel);
    }
    setState(() {});
  }

  List<DropdownMenuItem<String>> generateItemList() {
    return typeModelList.map<DropdownMenuItem<String>>((TslTypeModel e) {
      return DropdownMenuItem<String>(
        child: Container(
          margin:EdgeInsets.only(left: 5) ,
          child: Text(e.name),
        ),
        value: e.code,
      );
    }).toList();
  }

  Widget taskView(TslTransportTaskInfo item) {
    return InkWell(
      onTap: () {},
      child: Container(
        //设置 child 居中
        alignment: Alignment(0, 0),
        //边框设置
        decoration: new BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周边框
          border: new Border.all(width: 1, color: Colors.grey),
        ),
        child: Row(children: [
          Expanded(
            ///Expanded 按比例占据空间
            flex: 5,
            child: Column(
              children: [
                Container(
                  height: 30,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      taskTextView("装车单号"),
                      sizeBoxVertical(),
                      taskTextViewV2(item.load_sn),
                      sizeBoxVertical(),
                    ],
                  ),
                ),
                sizeBoxLevel(),
                Container(
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      taskTextView("车牌号码"),
                      sizeBoxVertical(),
                      taskTextViewV2(item.load_carNumber),
                      sizeBoxVertical(),
                    ],
                  ),
                ),
                sizeBoxLevel(),
                Container(
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      taskTextView("挂车车牌"),
                      sizeBoxVertical(),
                      taskTextViewV2(item.load_carNumber_cx),
                      sizeBoxVertical(),
                    ],
                  ),
                ),
                sizeBoxLevel(),
                Container(
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      taskTextView("集装箱号"),
                      sizeBoxVertical(),
                      taskTextViewV2(item.sload_trailerNumber),
                      sizeBoxVertical(),
                    ],
                  ),
                ),
                sizeBoxLevel(),
                Container(
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      taskTextView("封签号码"),
                      sizeBoxVertical(),
                      taskTextViewV2(item.load_fengqian),
                      sizeBoxVertical(),
                    ],
                  ),
                ),
                sizeBoxLevel(),
                Container(
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      taskTextView("当前状态"),
                      sizeBoxVertical(),
                      taskTextViewV2("yfc" == item.load_state ? "已发车" : "配载中"),
                      sizeBoxVertical(),
                    ],
                  ),
                ),
                sizeBoxLevel(),
                Container(
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      taskTextView("当前位置"),
                      sizeBoxVertical(),
                      taskTextViewV2(_location),
                      sizeBoxVertical(),
                    ],
                  ),
                ),
                sizeBoxLevel(),
                Container(
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      taskTextView("延误类型"),
                      sizeBoxVertical(),
                      // taskTextView(item.load_sendTime.toString()),
                      typeTextView(),
                      sizeBoxVertical(),
                    ],
                  ),
                ),
                sizeBoxLevel(),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  /**
   * 列表的文字展示控件
   */
  Widget taskTextView(String text) {
    return Expanded(
        flex: 1,
        child: Container(
          alignment: Alignment(0, 0),
          child: Text(
            text,
            textScaleFactor: 1.2,
          ),
        ));
  }

  /**
   * 列表的文字展示控件
   */
  Widget taskTextViewV2(String text) {
    return Expanded(
        flex: 2,
        child: Container(
          padding:EdgeInsets.only(left: 5) ,
          child: Text(
            text,
            textScaleFactor: 1.2,
          ),
        ));
  }

  /**
   * 下拉选择控件
   */
  Widget typeTextView() {
    return Expanded(
      flex: 2,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          // 下拉列表的数据
          items: generateItemList(),
          hint: DropdownMenuItem<String>(
            child:Container(
              margin:EdgeInsets.only(left: 5) ,
              child: Text("请选择"),
            ) ,
            value: "4000",
          ),
          // 改变事件
          onChanged: (value) {
            setState(() {
              selectItemValue = value.toString();
            });
          },
          value: selectItemValue,
          // 图标大小
          iconSize: 48,
          // 下拉文本样式
          style: TextStyle(fontSize: 18.0,color: Colors.grey),
        ),
      ),
    );
  }

  /**
   * 垂直分割线
   */
  Widget sizeBoxVertical() {
    return VerticalDivider(
      width: 1,
      thickness: 1,
      indent: 0,
      endIndent: 0,
      color: Colors.grey,
    );
  }

  /**
   * 水平分割线
   */
  Widget sizeBoxLevel() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 0,
      endIndent: 0,
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.

    return Scaffold(
      appBar: AppBar(
        title: Text("任务详情"),
      ),
      body: Container(
        child: taskView(info),
      ),
    );
  }
}
