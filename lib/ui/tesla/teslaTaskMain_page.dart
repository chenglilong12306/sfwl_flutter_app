import 'package:flutter/material.dart';
import 'package:sfwl_flutter_app/Constants.dart';

/**
 * FileName 特斯拉项目管理--项目任务
 * @Author lilong.chen
 * @Date 2022/7/18 15:55
 */

class TeslaTaskMainPage extends StatefulWidget{
  TeslaTaskMainPage({Key? super.key});

  @override
  TeslaTaskMainPageState createState() => TeslaTaskMainPageState();
}

class TeslaTaskMainPageState extends State<TeslaTaskMainPage>
    with AutomaticKeepAliveClientMixin<TeslaTaskMainPage>, WidgetsBindingObserver {

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
      appBar: AppBar(
        title: Text("特斯拉项目-项目任务"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: [
              Text("项目任务")
            ],
          )
        ],
      ),
    );
  }

}