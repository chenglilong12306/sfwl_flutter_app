import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sfwl_flutter_app/Constants.dart';
import 'package:sfwl_flutter_app/Global.dart';
import 'package:sfwl_flutter_app/common/net/Api.dart';
import 'package:sfwl_flutter_app/common/net/Dio_utils.dart';
import 'package:sfwl_flutter_app/common/utils/DateTimeUitl.dart';
import 'package:sfwl_flutter_app/common/utils/JsonUtil.dart';
import 'package:sfwl_flutter_app/model/TslTransportTaskInfoModel.dart';
import 'package:sfwl_flutter_app/model/request/getTslTransportTaskListModel.dart';

import '../../../model/TslWayillTranExecuteLoadInfoModel.dart';

/**
 * FileName 特斯拉项目管理--项目任务--历史记录
 * @Author lilong.chen
 * @Date 2022/10/25 15:55
 */

class TeslaTaskHistoryListPage extends StatefulWidget {
  TeslaTaskHistoryListPage({Key? super.key});

  @override
  TeslaTaskHistoryListPageState createState() =>
      TeslaTaskHistoryListPageState();
}

class TeslaTaskHistoryListPageState extends State<TeslaTaskHistoryListPage>
    with
        AutomaticKeepAliveClientMixin<TeslaTaskHistoryListPage>,
        WidgetsBindingObserver {
  List<TslTransportTaskInfo> taskInfoList = <TslTransportTaskInfo>[];

  @override
  void initState() {
    getDateList();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void getDateList() async {
    ///历史单据任务请求
    getTslTransportTaskListModel gettaskInfo;
    gettaskInfo = new getTslTransportTaskListModel(
        Global.spUtil.getString(Constants.USERID).toString(),
        Global.spUtil.getString(Constants.USERCOMID).toString());
    final res = await HttpUtils.instance.post(
      Api.getTslTransportTaskHistoryList,
      params: JsonUtil.setPostRequestParams(json.encode(gettaskInfo.toJson()),
              Global.spUtil.getString(Constants.USERID).toString())
          .toJson(),
      tips: true,
    );
    if(res.data.toString().length > 0){
      taskInfoList.clear();
    }
    for (var item in res.data) {
      TslTransportTaskInfo taskInfoModel = TslTransportTaskInfo.fromJson(item);
      /** 解析获取下级对象list*/
      List<TslWayillTranExecuteLoadInfoModel> M = <TslWayillTranExecuteLoadInfoModel>[];
      new List<Map<String, dynamic>>.from(jsonDecode(json.encode(taskInfoModel.modelList))).forEach((m) => M.add(TslWayillTranExecuteLoadInfoModel.fromJson(m)));
      taskInfoModel.modelList.add(M);
      taskInfoList.add(taskInfoModel);
    }
    setState(() {});
  }

  List<Widget> _getTaskViewData() {
    List<Widget> list = [];
    print("开始渲染数据" + list.length.toString());
    for (TslTransportTaskInfo item in taskInfoList) {
      list.add(taskView(item));
    }

    return list;
  }

  Widget taskView(TslTransportTaskInfo item) {
    return InkWell(
      onTap: () {

      },
      child: Container(
        //设置外边距
        margin: EdgeInsets.only(left:1,top: 5,right: 1,),
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
                      taskTextView(item.load_sn),
                      sizeBoxVertical(),
                    ],
                  ),
                ),
                sizeBoxLevel(),
                Container(
                  height: 30,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      taskTextView("发运编码"),
                      sizeBoxVertical(),
                      taskTextView(item.modelList[0]["way_print_sn"]),
                      sizeBoxVertical(),
                    ],
                  ),
                ),
                sizeBoxLevel(),
                Container(
                  height: 30,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      taskTextView("车牌号码"),
                      sizeBoxVertical(),
                      taskTextView(item.load_carNumber),
                      sizeBoxVertical(),
                    ],
                  ),
                ),
                sizeBoxLevel(),
                Container(
                  height: 30,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      taskTextView("挂车车牌"),
                      sizeBoxVertical(),
                      taskTextView(item.load_carNumber_cx),
                      sizeBoxVertical(),
                    ],
                  ),
                ),
                sizeBoxLevel(),
                Container(
                  height: 30,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      taskTextView("集装箱号"),
                      sizeBoxVertical(),
                      taskTextView(item.sload_trailerNumber),
                      sizeBoxVertical(),
                    ],
                  ),
                ),
                sizeBoxLevel(),
                Container(
                  height: 30,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      taskTextView("封签号码"),
                      sizeBoxVertical(),
                      taskTextView(item.load_fengqian),
                      sizeBoxVertical(),
                    ],
                  ),
                ),
                sizeBoxLevel(),
                Container(
                  height: 30,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      taskTextView("运输方向"),
                      sizeBoxVertical(),
                      taskTextView(item.load_Dirs),
                      sizeBoxVertical(),
                    ],
                  ),
                ),
                sizeBoxLevel(),
                Container(
                  height: 30,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      taskTextView("发车时间"),
                      sizeBoxVertical(),
                      taskTextView(DateTimeUtil.getDateTimeSwitchString(DateTimeUtil.getTimeStampSwitchDateTime(item.load_sendTime.toInt()),DateTimeUtil.YYYY_MM_DD)),
                      sizeBoxVertical(),
                    ],
                  ),
                ),sizeBoxLevel(),
                Container(
                  height: 30,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      taskTextView("运输状态"),
                      sizeBoxVertical(),
                      taskTextView("已完成"),
                      sizeBoxVertical(),
                    ],
                  ),
                ),
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
        title: Text("历史记录"),
      ),
      body: ListView(
        children: this._getTaskViewData(),
      ),
    );
  }
}
