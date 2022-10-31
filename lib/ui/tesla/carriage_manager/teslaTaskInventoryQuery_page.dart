import 'package:flutter/material.dart';

/**
 * FileName 特斯拉项目管理--库存查询
 * @Author lilong.chen
 * @Date 2022/7/18 15:55
 */

class TeslaTaskInventoryQueryPage extends StatefulWidget{
  TeslaTaskInventoryQueryPage({Key? super.key});

  @override
  TeslaTaskInventoryQueryPageState createState() => TeslaTaskInventoryQueryPageState();
}

class TeslaTaskInventoryQueryPageState extends State<TeslaTaskInventoryQueryPage>
    with AutomaticKeepAliveClientMixin<TeslaTaskInventoryQueryPage>, WidgetsBindingObserver {

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