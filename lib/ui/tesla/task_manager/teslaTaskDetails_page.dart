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
import 'package:sfwl_flutter_app/model/request/SetStartLoadStateModel.dart';
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
  late final TslTransportTaskInfo info;
  /**延误类型*/
  var typeSelectItemValue;
  /**车厢停放位置*/
  var addressSelectItemValue;
  List<TslTypeModel> typeModelList = <TslTypeModel>[];
  List<TslTypeModel> addressModelList = <TslTypeModel>[];
  String _loadAddress = '';
  String _loadLon = '';
  String _loadLat = '';
  bool _isButtonDisabledDDTH = true;
  bool _isButtonDisabledZCWC = true;
  bool _isButtonDisabledDDSH = true;
  String _buttonTextDDTH = "第一步，到达提货";
  String _buttonTextZCWC = "第二步，装车完成";
  String _buttonTextDDSH = "第三步，到达送货";

  LocationUtil location = LocationUtil();

  TeslaTaskDetailsPageState(this.info);

  @override
  void initState() {
    getTslDelayTypeInfo();
    getTslNewAddressTypeInfo();
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
      if (info.load_trdState == null || info.load_trdState == "") {
        if ("pzz" == info.load_state) {
          _isButtonDisabledDDTH = false;
          _isButtonDisabledZCWC = false;
          _isButtonDisabledDDSH = false;
        }
        if ("yfc" == info.load_state) {
          _isButtonDisabledDDTH = true;
          _isButtonDisabledZCWC = false;
          _isButtonDisabledDDSH = false;
        }
      } else {
        if ("tslddth" == info.load_trdState) {
          _isButtonDisabledDDTH = false;
          _isButtonDisabledZCWC = true;
          _isButtonDisabledDDSH = false;
          _buttonTextDDTH = "第一步，到达提货（已完成）";
        }
        if ("tslzcwc" == info.load_trdState) {
          _isButtonDisabledDDTH = false;
          _isButtonDisabledZCWC = false;
          _isButtonDisabledDDSH = true;
          _buttonTextDDTH = "第一步，到达提货（已完成）";
          _buttonTextZCWC = "第二步，装车完成（已完成）";
        }
        if ("tslddsh" == info.load_trdState || "tslwcjh" == info.load_trdState) {
          _isButtonDisabledDDTH = false;
          _isButtonDisabledZCWC = false;
          _isButtonDisabledDDSH = false;
          _buttonTextDDTH = "第一步，到达提货（已完成）";
          _buttonTextZCWC = "第二步，装车完成（已完成）";
          _buttonTextDDSH = "第三步，到达送货（已完成）";
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
                Container(
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      taskTextView("延误类型"),
                      sizeBoxVertical(),
                      typeTextView(typeModelList),
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
                      taskTextView("位置类型"),
                      sizeBoxVertical(),
                      addressTypeTextView(addressModelList),
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

  String loadStateText(){
    if (info.load_trdState == null || info.load_trdState == "") {
      if ("yfc" == info.load_state) {
        return "已发车";
      }
      if ("pzz" == info.load_state) {
        return "配载中";
      }
    }else{
      if ("tslddth" == info.load_trdState) {
        return "到达提货点";
      }
      if ("tslzcwc" == info.load_trdState) {
        return "装车完成";
      }
      if ("tslddsh" == info.load_trdState) {
        return "到达送货点";
      }
      if ("tslwcjh" == info.load_trdState) {
        return "已完成交货";
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
   * 下拉选择控件
   */
  Widget typeTextView(List<TslTypeModel> list) {
    return Expanded(
      flex: 2,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          // 下拉列表的数据
          items: generateItemList(list),
          hint: DropdownMenuItem<String>(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text("请选择"),
            ),
            value: "4000",
          ),
          // 改变事件
          onChanged: (value) {
            setState(() {
              typeSelectItemValue = value.toString();
            });
          },
          value: typeSelectItemValue,
          // 图标大小
          iconSize: 48,
          // 下拉文本样式
          style: TextStyle(fontSize: 18.0, color: Colors.grey),
        ),
      ),
    );
  }

  /**
   * 下拉选择控件
   */
  Widget addressTypeTextView(List<TslTypeModel> list) {
    return Expanded(
      flex: 2,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          // 下拉列表的数据
          items: generateItemList(list),
          hint: DropdownMenuItem<String>(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text("请选择"),
            ),
            value: "4000",
          ),
          // 改变事件
          onChanged: (value) {
            setState(() {
              addressSelectItemValue = value.toString();
            });
          },
          value: addressSelectItemValue,
          // 图标大小
          iconSize: 48,
          // 下拉文本样式
          style: TextStyle(fontSize: 18.0, color: Colors.grey),
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

  /**
   * 可变换禁用情况的按钮
   */
  Widget buttonView_ddth(String button_name) {
    return MaterialButton(
      ///按钮的背景
      color: _isButtonDisabledDDTH ? Colors.blue : Colors.grey,
      child: Text(button_name,
          style: TextStyle(color: Colors.white, fontSize: 16)),

      ///点击回调函数
      onPressed: () => _isButtonDisabledDDTH ? SetStartLoadState("tslddth") : null,

      ///按钮按下时回调 value = true
      ///按钮抬起时回调 value = false
      ///要先于 onPressed
      onHighlightChanged: (value) {
        // print("按钮点击 Hight $value");
        // Fluttertoast.showToast(msg: "按钮点击 Hight $value");
        if ("tslddth" == info.load_trdState) {
          Fluttertoast.showToast(msg: "已到达提货点！");
          return;
        }
        if ("tslzcwc" == info.load_trdState) {
          Fluttertoast.showToast(msg: "已装车完成");
          return;
        }
        if ("tslddsh" == info.load_trdState) {
          Fluttertoast.showToast(msg: "已到达送货点");
          return;
        }
        if ("tslwcjh" == info.load_trdState) {
          Fluttertoast.showToast(msg: "已完成交货");
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
      highlightColor:  _isButtonDisabledDDTH ? Colors.deepPurple : null,

      ///水波方的颜色
      splashColor: _isButtonDisabledDDTH ? Colors.green : null,

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

  Widget buttonView_zcwc(String button_name) {
    return MaterialButton(
      ///按钮的背景
      color: _isButtonDisabledZCWC ? Colors.blue : Colors.grey,
      child: Text(button_name,
          style: TextStyle(color: Colors.white, fontSize: 16)),

      ///点击回调函数
      onPressed: () => _isButtonDisabledZCWC ? SetStartLoadState("tslzcwc") : null,

      ///按钮按下时回调 value = true
      ///按钮抬起时回调 value = false
      ///要先于 onPressed
      onHighlightChanged: (value) {

        if ("tslzcwc" == info.load_trdState) {
          Fluttertoast.showToast(msg: "已装车完成");
          return;
        }
        if ("tslddsh" == info.load_trdState) {
          Fluttertoast.showToast(msg: "已到达送货点");
          return;
        }
        if ("tslwcjh" == info.load_trdState) {
          Fluttertoast.showToast(msg: "已完成交货");
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
      highlightColor: _isButtonDisabledZCWC ? Colors.deepPurple : null,

      ///水波方的颜色
      splashColor: _isButtonDisabledZCWC ? Colors.green : null,

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

  Widget buttonView_ddsh(String button_name) {
    return MaterialButton(
      ///按钮的背景
      color: _isButtonDisabledDDSH ? Colors.blue : Colors.grey,
      child: Text(button_name,
          style: TextStyle(color: Colors.white, fontSize: 16)),

      ///点击回调函数
      onPressed: () => _isButtonDisabledDDSH ? SetStartLoadState("tslddsh") : null,

      ///按钮按下时回调 value = true
      ///按钮抬起时回调 value = false
      ///要先于 onPressed
      onHighlightChanged: (value) {

        if ("tslddth" == info.load_trdState) {
          Fluttertoast.showToast(msg: "已到达提货点！");
          return;
        }
        if ("tslddsh" == info.load_trdState) {
          Fluttertoast.showToast(msg: "已到达送货点");
          return;
        }
        if ("tslwcjh" == info.load_trdState) {
          Fluttertoast.showToast(msg: "已完成交货");
          return;
        }
        if (_loadLon == 0 || _loadLat == 0) {
          Fluttertoast.showToast(msg: "定位地址为空！");
          return;
        }
        if (addressSelectItemValue == null || "" == addressSelectItemValue) {
          Fluttertoast.showToast(msg: "请选择车厢所在位置");
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
      highlightColor: _isButtonDisabledDDSH ? Colors.deepPurple : null,

      ///水波方的颜色
      splashColor: _isButtonDisabledDDSH ? Colors.green : null,

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
  void SetStartLoadState(String loadState) async {
    SetStartLoadStateModel stateModel;
    stateModel = new SetStartLoadStateModel(
        Global.spUtil.getString(Constants.USERID).toString(),
        Global.spUtil.getString(Constants.USERCOMID).toString(),
        info.load_id,
        loadState,
        _loadLon,
        _loadLat,
        _loadAddress,
        typeSelectItemValue == null ? "" : typeSelectItemValue,
        addressSelectItemValue == null ? "" : addressSelectItemValue);
    final res = await HttpUtils.instance.post(
      Api.setStartLoadState,
      params: JsonUtil.setPostRequestParams(json.encode(stateModel.toJson()),
              Global.spUtil.getString(Constants.USERID).toString())
          .toJson(),
      tips: true,
    );
    TslTransportTaskInfo taskInfoModel = TslTransportTaskInfo.fromJson(res.data);
    /** 刷新当前页面的值 */
    info.load_state = taskInfoModel.load_state;
    info.load_trdState = taskInfoModel.load_trdState;
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
            buttonView_ddth(_buttonTextDDTH),
            buttonView_zcwc(_buttonTextZCWC),
            buttonView_ddsh(_buttonTextDDSH),
          ],
        ),
      ),
    );
  }
}

