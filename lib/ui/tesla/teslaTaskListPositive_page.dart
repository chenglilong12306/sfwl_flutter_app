import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sfwl_flutter_app/Constants.dart';
import 'package:sfwl_flutter_app/Global.dart';
import 'package:sfwl_flutter_app/common/net/Api.dart';
import 'package:sfwl_flutter_app/common/net/Dio_utils.dart';
import 'package:sfwl_flutter_app/common/utils/JsonUtil.dart';
import 'package:sfwl_flutter_app/model/TslTransportTaskInfoModel.dart';
import 'package:sfwl_flutter_app/model/request/getTslTransportTaskListModel.dart';

/**
 * FileName 特斯拉项目管理--项目任务--正向
 * @Author lilong.chen
 * @Date 2022/7/18 15:55
 */

class TeslaTaskListPositivePage extends StatefulWidget{
  TeslaTaskListPositivePage({Key? super.key});

  @override
  TeslaTaskListPositivePageState createState() => TeslaTaskListPositivePageState();
}

class TeslaTaskListPositivePageState extends State<TeslaTaskListPositivePage>
    with AutomaticKeepAliveClientMixin<TeslaTaskListPositivePage>, WidgetsBindingObserver {

  List<TslTransportTaskInfo> list = <TslTransportTaskInfo>[];
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
    ///登录请求
    getTslTransportTaskListModel gettaskInfo;
    gettaskInfo = new getTslTransportTaskListModel(Global.spUtil.getString(Constants.USERID).toString(),Global.spUtil.getString(Constants.USERSUPID).toString());
    final res = await HttpUtils.instance.post(
      Api.getTslTransportTaskList,
      params:JsonUtil.setPostRequestParams(json.encode(gettaskInfo.toJson()), Global.spUtil.getString(Constants.USERID).toString()).toJson(),
      tips: true,
    );
    for(var item in res.data) {
      TslTransportTaskInfo appMenuModel = TslTransportTaskInfo.fromJson(item);
      list.add(appMenuModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return Scaffold(
      body: Text("特斯拉项目-项目任务-正向"),
    );
  }

}