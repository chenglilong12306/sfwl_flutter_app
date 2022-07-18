import 'package:flutter/material.dart';

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
        title: Text("我的"),
        automaticallyImplyLeading: false,///隐藏返回按钮
      ),
      body: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: "我的",
              prefixIcon: Icon(Icons.person),
            ),
          ),
        ],
      ),
    );
  }
}
