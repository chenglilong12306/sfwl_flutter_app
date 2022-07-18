import 'package:flutter/material.dart';

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
        title: Text("特斯拉项目-车厢管理"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: [
              Text("车厢管理")
            ],
          )
        ],
      ),
    );
  }

}