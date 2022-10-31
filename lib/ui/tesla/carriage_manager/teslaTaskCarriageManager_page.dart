import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sfwl_flutter_app/model/TslCarTrackAreaInfoModel.dart';

import '../../../Constants.dart';
import '../../../Global.dart';
import '../../../common/net/Api.dart';
import '../../../common/net/Dio_utils.dart';
import '../../../common/utils/JsonUtil.dart';
import '../../../model/TslTypeModel.dart';
import '../../../model/request/getTslInOutTypeInfoModel.dart';
import '../../../model/request/getTslTransportTaskListModel.dart';
import '../../../utils/LocationUtil.dart';

/**
 * FileName 特斯拉项目管理--车厢管理
 * @Author lilong.chen
 * @Date 2022/7/18 15:55
 */

class TeslaTaskCarriageManagerPage extends StatefulWidget {
  TeslaTaskCarriageManagerPage({Key? super.key});

  @override
  TeslaTaskCarriageManagerPageState createState() =>
      TeslaTaskCarriageManagerPageState();
}

class TeslaTaskCarriageManagerPageState
    extends State<TeslaTaskCarriageManagerPage>
    with
        AutomaticKeepAliveClientMixin<TeslaTaskCarriageManagerPage>,
        WidgetsBindingObserver {

  /**库区库位行列数*/
  List<int> areaLineInfo = <int>[];
  List<int> areaColumnInfo = <int>[];
  /**库区列表*/
  List<TslCarTrackAreaInfoModel> areaList = <TslCarTrackAreaInfoModel>[];

  /**车厢停放位置*/
  var addressSelectItemValue;
  List<TslTypeModel> addressModelList = <TslTypeModel>[];
  /**车厢类型接口*/
  var vehicleTypeInfoValue;
  List<TslTypeModel> vehicleTypeInfoList = <TslTypeModel>[];

  /**进出类型--进出*/
  var inOutInfoValue = "";
  List<TslTypeModel> inOutInfoList = <TslTypeModel>[];

  /**进出类型*/
  var inOutTypeInfoValue = "";
  List<TslTypeModel> inOutTypeInfoList = <TslTypeModel>[];
  /*进入*/
  List<TslTypeModel> inOutTypeInfoList1 = <TslTypeModel>[];
  /*离开*/
  List<TslTypeModel> inOutTypeInfoList3 = <TslTypeModel>[];
  String _loadAddress = '';
  String _loadLon = '';
  String _loadLat = '';
  LocationUtil location = LocationUtil();

  @override
  void initState() {
    getTslNewAddressTypeInfo();
    getTslVehicleTypeInfo();
    getTslInOutTypeInfo("1");
    getTslInOutTypeInfo("3");
    /**初始化进出类型--进出*/
    inOutInfoList.add(TslTypeModel("", "请选择"));
    inOutInfoList.add(TslTypeModel("1", "进入"));
    inOutInfoList.add(TslTypeModel("3", "离开"));

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
      if ("kh" != tslTypeModel.code && "0" != tslTypeModel.code) {
        addressModelList.add(tslTypeModel);
      }
    }
    setState(() {});
  }
  void getTslVehicleTypeInfo() async {
    ///获取车厢停放位置类型
    getTslTransportTaskListModel gettaskInfo;
    gettaskInfo = new getTslTransportTaskListModel(
        Global.spUtil.getString(Constants.USERID).toString(),
        Global.spUtil.getString(Constants.USERCOMID).toString());
    final res = await HttpUtils.instance.post(
      Api.getTslVehicleTypeInfo,
      params: JsonUtil.setPostRequestParams(json.encode(gettaskInfo.toJson()),
              Global.spUtil.getString(Constants.USERID).toString())
          .toJson(),
      tips: true,
    );
    for (var item in res.data) {
      TslTypeModel tslTypeModel = TslTypeModel.fromJson(item);
      vehicleTypeInfoList.add(tslTypeModel);
    }
    setState(() {});
  }

  void getTslInOutTypeInfo(String action) async {
    ///获取特斯拉--进/出（停车场/堆场）类型接口
    if("" != action) {
      getTslInOutTypeInfoModel getTslInOutTypeInfo = new getTslInOutTypeInfoModel(
          action);
      final res = await HttpUtils.instance.post(
        Api.getTslInOutTypeInfo,
        params: JsonUtil.setPostRequestParams(json.encode(getTslInOutTypeInfo),
            Global.spUtil.getString(Constants.USERID).toString())
            .toJson(),
        tips: true,
      );
      for (var item in res.data) {
        TslTypeModel tslTypeModel = TslTypeModel.fromJson(item);
        if("1" == action){
          inOutTypeInfoList1.add(tslTypeModel);
        }
        if("3" == action){
          inOutTypeInfoList3.add(tslTypeModel);
        }
      }
      setState(() {

      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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

  /**
   * 所在场所下拉选择控件
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
              child: Text(list.length == 0 ? "请选择" : list[0].name),
            ),
            value: list.length == 0 ? "0" : list[0].code,
          ),
          // 改变事件
          onChanged: (value) {
            setState(() {
              addressSelectItemValue = value.toString();
            });
          },
          value: addressSelectItemValue,
          // 图标大小
          iconSize: 24,
          // 下拉文本样式
          style: TextStyle(fontSize: 18.0, color: Colors.grey),
        ),
      ),
    );
  }
  /**
   * 车厢类型下拉选择控件
   */
  Widget vehicleTypeInfoTextView(List<TslTypeModel> list) {
    return Expanded(
      flex: 2,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          // 下拉列表的数据
          items: generateItemList(list),
          hint: DropdownMenuItem<String>(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(list.length == 0 ? "请选择" : list[1].name),
            ),
            value: list.length == 0 ? "0" : list[1].code,
          ),
          // 改变事件
          onChanged: (value) {
            setState(() {
              vehicleTypeInfoValue = value.toString();
            });
          },
          value: vehicleTypeInfoValue,
          // 图标大小
          iconSize: 24,
          // 下拉文本样式
          style: TextStyle(fontSize: 18.0, color: Colors.grey),
        ),
      ),
    );
  }
  /**
   * 联动下拉选择框--一级下拉选择控件
   */
  Widget inOutInfoTextView(List<TslTypeModel> list) {
    return Expanded(
      flex: 2,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          // 下拉列表的数据
          items: generateItemList(list),
          hint: DropdownMenuItem<String>(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(list.length == 0 ? "请选择" : list[0].name),
            ),
            value: list.length == 0 ? "0" : list[0].code,
          ),
          // 改变事件
          onChanged: (value) {
            setState(() {
              inOutInfoValue = value.toString();
              if("1" == inOutInfoValue){
                inOutTypeInfoList = inOutTypeInfoList1;
              }
              if("3" == inOutInfoValue){
                inOutTypeInfoList = inOutTypeInfoList3;
              }
              inOutTypeInfoValue = inOutTypeInfoList[0].code;
            });
          },
          value: inOutInfoValue,
          // 图标大小
          iconSize: 24,
          // 下拉文本样式
          style: TextStyle(fontSize: 14.0, color: Colors.grey),
        ),
      ),
    );
  }
  /**
   * 联动下拉选择框--二级下拉选择控件
   */
  Widget inOutInfoValueTextView(List<TslTypeModel> list) {
    return Expanded(
      flex: 2,
      child: DropdownButtonHideUnderline(
        child : DropdownButton<String>(
          // 下拉列表的数据
          items: generateItemList(list),
          hint: DropdownMenuItem<String>(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text("请选择"),
            ),
            value: "0",
          ),
          // 改变事件
          onChanged: (value) {
            setState(() {
              inOutTypeInfoValue = value.toString();
            });
          },
          value: inOutTypeInfoValue,
          // 图标大小
          iconSize: 24,
          // 下拉文本样式
          style: TextStyle(fontSize: 14.0, color: Colors.grey),
        ),
      ),
    );
  }

  /**
   * 车厢号输入查询框
   * 知识点：TextField 与 Row 嵌套使用需要在 TextField前套上 Expanded使用
   */
  Widget carCxNumberEditView() {
    return Row(
      children: [
        Expanded(
          child: // 单行文本输入框
              TextField(
            decoration: InputDecoration(
              hintText: "请输入车厢号",
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            //设置外边距
            margin: EdgeInsets.all(10),
            //设置内边距
            padding: EdgeInsets.all(10),
            //设置 child 居中
            alignment: Alignment(0, 0),
            //边框设置
            decoration: new BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              //设置四周边框
              border: new Border.all(width: 1, color: Colors.grey),
            ),
            child: Column(children: [
              Text("查询"),
            ]),
          ),
        )
      ],
    );
  }

  /**
   * 车厢场所库区进出块
   */
  Widget carriageView() {
    return Column(
      children: [
        sizeBoxLevel(),
        Container(
          height: 50,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              sizeBoxVertical(),
              taskTextView("位置类型"),
              sizeBoxVertical(),
              addressTypeTextView(addressModelList),
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
              sizeBoxVertical(),
              taskTextView("车厢类型"),
              sizeBoxVertical(),
              vehicleTypeInfoTextView(vehicleTypeInfoList),
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
              sizeBoxVertical(),
              taskTextView("进出类型"),
              sizeBoxVertical(),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    inOutInfoTextView(inOutInfoList),
                    sizeBoxLevel(),
                    inOutInfoValueTextView(inOutTypeInfoList),
                  ],
                ),
              ),
              sizeBoxVertical(),
            ],
          ),
        ),
        sizeBoxLevel(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            carCxNumberEditView(),
            carriageView(),
          ],
        ),
      ),
    );
  }
}
