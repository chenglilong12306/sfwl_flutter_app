import 'package:flutter/material.dart';

/**
 * FileName 特斯拉项目管理--项目任务--返空
 * @Author lilong.chen
 * @Date 2022/7/18 15:55
 */

class TeslaTaskListReturnEmptyPage extends StatefulWidget{
  TeslaTaskListReturnEmptyPage({Key? super.key});

  @override
  TeslaTaskListReturnEmptyPageState createState() => TeslaTaskListReturnEmptyPageState();
}

class TeslaTaskListReturnEmptyPageState extends State<TeslaTaskListReturnEmptyPage>
    with AutomaticKeepAliveClientMixin<TeslaTaskListReturnEmptyPage>, WidgetsBindingObserver {

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
    super.build(context); // See AutomaticKeepAliveClientMixin.

    return Scaffold(
      body: Text("特斯拉项目-项目任务-返空"),
    );
  }

}