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
import 'package:sfwl_flutter_app/model/request/SetReturnStartLoadStateModel.dart';
import 'package:sfwl_flutter_app/model/request/SetStartLoadStateModel.dart';
import 'package:sfwl_flutter_app/model/request/getTslTransportTaskListModel.dart';
import 'package:sfwl_flutter_app/utils/LocationUtil.dart';

import '../../../model/TslWayillTranExecuteLoadInfoModel.dart';

/**
 * FileName 特斯拉返空任务详情页面
 * @Author lilong.chen
 * @Date 2022/9/7 14:36
 */

class TeslaTaskReturnDetailsPage extends StatefulWidget {
  final TslTransportTaskInfo info;

  TeslaTaskReturnDetailsPage(this.info, {Key? super.key});

  @override
  TeslaTaskReturnDetailsPageState createState() =>
      TeslaTaskReturnDetailsPageState(info);
}

class TeslaTaskReturnDetailsPageState extends State<TeslaTaskReturnDetailsPage>
    with
        AutomaticKeepAliveClientMixin<TeslaTaskReturnDetailsPage>,
        WidgetsBindingObserver {
  late final TslTransportTaskInfo info;
  List<TslTypeModel> addressModelList = <TslTypeModel>[];
  String _loadAddress = '';
  String _loadLon = '';
  String _loadLat = '';
  bool _isButtonDisabledKH = true;
  bool _isButtonDisabledQS = true;
  String _buttonTextKH = "第一步，到达供应商客户";
  String _buttonTextQS = "第二步，供应商客户签收";

  LocationUtil location = LocationUtil();

  TeslaTaskReturnDetailsPageState(this.info);

  @override
  void initState() {
    _incrementCounter();
    super.initState();

    location.getCurrentLocation((Map result) {
      setState(() {
        print('接收到result:$result');
        _loadAddress = result["address"];
        _loadLon = result["longitude"].toString();
        _loadLat = result["latitude"].toString();
      });
    }).catchError((err) {
      Fluttertoast.showToast(msg: err);
    });
  }

  void _incrementCounter() {
    setState(() {
      if (info.load_tracState == null || info.load_tracState == "") {
        if ("pzz" == info.load_state) {
          _isButtonDisabledKH = false;
          _isButtonDisabledQS = false;
        }
        if ("yfc" == info.load_state) {
          _isButtonDisabledKH = true;
          _isButtonDisabledQS = false;
        }
      } else {
        if ("kh" == info.load_tracState) {
          _isButtonDisabledKH = false;
          _isButtonDisabledQS = true;
          _buttonTextKH = "第一步，到达供应商客户（已完成）";
        }
        if ("qs" == info.load_tracState) {
          _isButtonDisabledKH = false;
          _isButtonDisabledQS = false;
          _buttonTextKH = "第一步，到达供应商客户（已完成）";
          _buttonTextQS = "第二步，供应商客户签收（已完成）";
        }
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void getTslNewAddressTypeInfo() async {
    ///获取车厢停放位置类型
    getTslTransportTaskListModel gettaskInfo;
    gettaskInfo = new getTslTransportTaskListModel(
        Global.spUtil.getString(Constants.USERID).toString(),
        Global.spUtil.getString(Constants.USERCOMID).toString());
    final res = await HttpUtils.instance.post(
      Api.getTslNewAddressTypeInfo,
      params: JsonUtil.setPostRequestParams(json.encode(gettaskInfo.toJson()),
              Global.spUtil.getString(Constants.USERID).toString())
          .toJson(),
      tips: true,
    );
    for (var item in res.data) {
      TslTypeModel tslTypeModel = TslTypeModel.fromJson(item);
      addressModelList.add(tslTypeModel);
    }
    setState(() {});
  }

  List<DropdownMenuItem<String>> generateItemList(List<TslTypeModel> list) {
    return list.map<DropdownMenuItem<String>>((TslTypeModel e) {
      return DropdownMenuItem<String>(
        child: Container(
          margin: EdgeInsets.only(left: 5),
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
                  height: 50,
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
                      taskTextView("发运编码"),
                      sizeBoxVertical(),
                      taskTextViewV2(item.modelList[0]["way_print_sn"]),
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
                      taskTextViewV2(loadStateText()),
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
                      taskTextViewV2(_loadAddress),
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

  String loadStateText() {
    if (info.load_tracState == null || info.load_tracState == "") {
      if ("yfc" == info.load_state) {
        return "已发车";
      }
      if ("pzz" == info.load_state) {
        return "配载中";
      }
    } else {
      if ("kh" == info.load_tracState) {
        return "到达供应商客户";
      }
      if ("qs" == info.load_tracState) {
        return "供应商客户签收";
      }
    }
    return "";
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
          padding: EdgeInsets.only(left: 5),
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

  /**
   * 可变换禁用情况的按钮
   */
  Widget buttonView_kh(String button_name) {
    return MaterialButton(
      ///按钮的背景
      color: _isButtonDisabledKH ? Colors.blue : Colors.grey,
      child: Text(button_name,
          style: TextStyle(color: Colors.white, fontSize: 16)),

      ///点击回调函数
      onPressed: () =>
          _isButtonDisabledKH ? SetStartLoadState("tslfkdg", "kh") : null,

      ///按钮按下时回调 value = true
      ///按钮抬起时回调 value = false
      ///要先于 onPressed
      onHighlightChanged: (value) {
        // print("按钮点击 Hight $value");
        // Fluttertoast.showToast(msg: "按钮点击 Hight $value");
        if ("kh" == info.load_trdState) {
          Fluttertoast.showToast(msg: "已到达提货点！");
          return;
        }
        if (_loadLon == 0 || _loadLat == 0) {
          Fluttertoast.showToast(msg: "定位地址为空！");
          return;
        }
      },

      ///定义按钮的基色，以及按钮的最小尺寸
      ///ButtonTextTheme.accent 按钮显示的文本 ThemeData.accentColor(MaterialApp组件中的theme属性配制的)
      ///ButtonTextTheme. normal 按钮显示的文本 黑色或者白色 具体取决于ThemeData.brightness Brightness.dark
      ///ButtonTextTheme.primary 按钮的显示的文本 ThemeData.primaryColr
      textTheme: ButtonTextTheme.primary,

      ///配制按钮上文本的颜色
      textColor: Colors.deepOrange,

      ///未设置点击时的背景颜色
      disabledColor: Colors.grey,

      ///按钮点击下的颜色
      highlightColor: _isButtonDisabledKH ? Colors.deepPurple : null,

      ///水波方的颜色
      splashColor: _isButtonDisabledKH ? Colors.green : null,

      ///按钮的阴影
      elevation: 10,

      ///按钮按下时的阴影高度
      highlightElevation: 20,

      ///未设置点击时的阴影高度
      disabledElevation: 5.0,

      ///用来设置按钮的边框的样式
      /// Border.all(color: Colors.deepOrange,width: 2.5,style:  BorderStyle.solid) 四个边框
      /// Border(bottom: BorderSide(color: Colors.deepOrange,width: 2.5,style:  BorderStyle.solid)) 可以分别设置边框
      /// 用来设置底部边框的
      /// UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepOrange,width: 2.5,style:  BorderStyle.solid),borderRadius: BorderRadius.circular(10))
      /// 用来设置圆角矩形边框
      ///   RoundedRectangleBorder(side: BorderSide.none,borderRadius: BorderRadius.all(Radius.circular(20)))
      ///   用来设置圆形边框
      ///   CircleBorder(side: BorderSide(width: 2,color:Colors.red )),
      ///   椭圆形边框 StadiumBorder(side: BorderSide(width: 2,color: Colors.red))
      ///   设置 多边形 BeveledRectangleBorder(side: BorderSide(width: 2,color: Colors.red),borderRadius: BorderRadius.all(Radius.circular(20)))
      ///
      shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      height: 44.0,
      minWidth: 140,
    );
  }

  Widget buttonView_qs(String button_name) {
    return MaterialButton(
      ///按钮的背景
      color: _isButtonDisabledQS ? Colors.blue : Colors.grey,
      child: Text(button_name,
          style: TextStyle(color: Colors.white, fontSize: 16)),

      ///点击回调函数
      onPressed: () =>
          _isButtonDisabledQS ? SetStartLoadState("tslfkqs", "qs") : null,

      ///按钮按下时回调 value = true
      ///按钮抬起时回调 value = false
      ///要先于 onPressed
      onHighlightChanged: (value) {
        if ("qs" == info.load_trdState) {
          Fluttertoast.showToast(msg: "已装车完成");
          return;
        }
        if (_loadLon == 0 || _loadLat == 0) {
          Fluttertoast.showToast(msg: "定位地址为空！");
          return;
        }
      },

      ///定义按钮的基色，以及按钮的最小尺寸
      ///ButtonTextTheme.accent 按钮显示的文本 ThemeData.accentColor(MaterialApp组件中的theme属性配制的)
      ///ButtonTextTheme. normal 按钮显示的文本 黑色或者白色 具体取决于ThemeData.brightness Brightness.dark
      ///ButtonTextTheme.primary 按钮的显示的文本 ThemeData.primaryColr
      textTheme: ButtonTextTheme.primary,

      ///配制按钮上文本的颜色
      textColor: Colors.deepOrange,

      ///未设置点击时的背景颜色
      disabledColor: Colors.grey,

      ///按钮点击下的颜色
      highlightColor: _isButtonDisabledQS ? Colors.deepPurple : null,

      ///水波方的颜色
      splashColor: _isButtonDisabledQS ? Colors.green : null,

      ///按钮的阴影
      elevation: 10,

      ///按钮按下时的阴影高度
      highlightElevation: 20,

      ///未设置点击时的阴影高度
      disabledElevation: 5.0,

      ///用来设置按钮的边框的样式
      /// Border.all(color: Colors.deepOrange,width: 2.5,style:  BorderStyle.solid) 四个边框
      /// Border(bottom: BorderSide(color: Colors.deepOrange,width: 2.5,style:  BorderStyle.solid)) 可以分别设置边框
      /// 用来设置底部边框的
      /// UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepOrange,width: 2.5,style:  BorderStyle.solid),borderRadius: BorderRadius.circular(10))
      /// 用来设置圆角矩形边框
      ///   RoundedRectangleBorder(side: BorderSide.none,borderRadius: BorderRadius.all(Radius.circular(20)))
      ///   用来设置圆形边框
      ///   CircleBorder(side: BorderSide(width: 2,color:Colors.red )),
      ///   椭圆形边框 StadiumBorder(side: BorderSide(width: 2,color: Colors.red))
      ///   设置 多边形 BeveledRectangleBorder(side: BorderSide(width: 2,color: Colors.red),borderRadius: BorderRadius.all(Radius.circular(20)))
      ///
      shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      height: 44.0,
      minWidth: 140,
    );
  }

  /**
   * 设置装车单状态
   */
  void SetStartLoadState(
      String loadState, String loadNewAddressTypeCode) async {
    SetReturnStartLoadStateModel stateModel;
    stateModel = new SetReturnStartLoadStateModel(
        Global.spUtil.getString(Constants.USERID).toString(),
        Global.spUtil.getString(Constants.USERCOMID).toString(),
        info.load_id,
        loadState,
        _loadLon,
        _loadLat,
        _loadAddress,
        loadNewAddressTypeCode);
    final res = await HttpUtils.instance.post(
      Api.setStartLoadStateReturnEmpty,
      params: JsonUtil.setPostRequestParams(json.encode(stateModel.toJson()),
              Global.spUtil.getString(Constants.USERID).toString())
          .toJson(),
      tips: true,
    );
    TslTransportTaskInfo taskInfoModel =
        TslTransportTaskInfo.fromJson(res.data);
    // List<TslWayillTranExecuteLoadInfoModel> M = <TslWayillTranExecuteLoadInfoModel>[];
    // new List<Map<String, dynamic>>.from(jsonDecode(json.encode(taskInfoModel.modelList))).forEach((m) => M.add(TslWayillTranExecuteLoadInfoModel.fromJson(m)));
    // taskInfoModel.modelList.add(M);
    /** 刷新当前页面的值 */
    info.load_state = taskInfoModel.load_state;
    info.load_tracState = taskInfoModel.load_tracState;
    _incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.

    return Scaffold(
      appBar: AppBar(
        title: Text("任务详情"),
      ),
      body: Container(
        child: Column(
          children: [
            taskView(info),
            buttonView_kh(_buttonTextKH),
            buttonView_qs(_buttonTextQS),
          ],
        ),
      ),
    );
  }
}
