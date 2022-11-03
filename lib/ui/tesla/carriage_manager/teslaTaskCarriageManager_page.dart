import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sfwl_flutter_app/model/BasCarInfoModel.dart';
import 'package:sfwl_flutter_app/model/TslCarTrackAreaInfoModel.dart';
import 'package:sfwl_flutter_app/model/request/getCarInfoListModel.dart';

import '../../../Constants.dart';
import '../../../Global.dart';
import '../../../common/net/Api.dart';
import '../../../common/net/Dio_utils.dart';
import '../../../common/utils/JsonUtil.dart';
import '../../../model/TeslaCarTrackInfoModel.dart';
import '../../../model/TslTypeModel.dart';
import '../../../model/request/getTeslaCarTrackAreaInfoModel.dart';
import '../../../model/request/getTeslaCarTrackByCarNumberModel.dart';
import '../../../model/request/getTslInOutTypeInfoModel.dart';
import '../../../model/request/getTslTransportTaskListModel.dart';
import '../../../model/request/setTslTaskCarTrackModel.dart';
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
  var _isButtonSubmit = true;

  TextEditingController _carNumberController = TextEditingController();
  var carNumberVisible = false;

  /**车辆信息*/
  List<BasCarInfoModel> carInfoList = <BasCarInfoModel>[];
  late BasCarInfoModel carInfo = BasCarInfoModel.init();

  /**库区库位行列数*/
  List<String> areaLineInfoList = <String>[];
  var areaLineInfoValue;
  List<String> areaColumnInfoList = <String>[];
  var areaColumnInfoValue;

  /**库区列表*/
  List<TslCarTrackAreaInfoModel> areaList = <TslCarTrackAreaInfoModel>[];
  late TslCarTrackAreaInfoModel areaListValue = TslCarTrackAreaInfoModel.init();

  /**特斯拉车厢跟踪列表*/
  List<TeslaCarTrackInfo> carTrackInfoList = <TeslaCarTrackInfo>[];
  late TeslaCarTrackInfo carTrackInfoListValue = TeslaCarTrackInfo.init();

  /**车厢停放位置 -- 所在场所*/
  var addressSelectItemValue = "tcc";
  var addressTypeCodeName;
  List<TslTypeModel> addressModelList = <TslTypeModel>[];

  /**车厢类型接口*/
  var vehicleTypeInfoValue;
  var vehicleTypeInfoValueName;
  List<TslTypeModel> vehicleTypeInfoList = <TslTypeModel>[];

  /**进出类型--进出*/
  var inOutInfoValue = "";
  List<TslTypeModel> inOutInfoList = <TslTypeModel>[];

  /**进出类型*/
  var inOutTypeInfoValue = "";
  var inOutTypeInfoValueName;
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
    getTeslaCarTrackAreaInfoList(addressSelectItemValue);
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
    ///获取车厢类型
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
    if ("" != action) {
      getTslInOutTypeInfoModel getTslInOutTypeInfo =
          new getTslInOutTypeInfoModel(action);
      final res = await HttpUtils.instance.post(
        Api.getTslInOutTypeInfo,
        params: JsonUtil.setPostRequestParams(json.encode(getTslInOutTypeInfo),
                Global.spUtil.getString(Constants.USERID).toString())
            .toJson(),
        tips: true,
      );
      for (var item in res.data) {
        TslTypeModel tslTypeModel = TslTypeModel.fromJson(item);
        if ("1" == action) {
          inOutTypeInfoList1.add(tslTypeModel);
        }
        if ("3" == action) {
          inOutTypeInfoList3.add(tslTypeModel);
        }
      }
      setState(() {});
    }
  }

  void getTeslaCarTrackAreaInfoList(String area_locationType) async {
    ///根据位置类型查询库区
    getTeslaCarTrackAreaInfoModel getTeslaCarTrackAreaInfo =
        new getTeslaCarTrackAreaInfoModel(
            area_locationType,
            Global.spUtil.getString(Constants.USERID).toString(),
            Global.spUtil.getString(Constants.USERCOMID).toString());
    final res = await HttpUtils.instance.post(
      Api.getTeslaCarTrackAreaInfoList,
      params: JsonUtil.setPostRequestParams(
              json.encode(getTeslaCarTrackAreaInfo),
              Global.spUtil.getString(Constants.USERID).toString())
          .toJson(),
      tips: true,
    );
    areaList.clear();
    areaListValue = TslCarTrackAreaInfoModel.init();
    areaLineInfoValue = "1";
    areaColumnInfoValue = "1";
    for (var item in res.data) {
      TslCarTrackAreaInfoModel trackAreaInfoModel =
          TslCarTrackAreaInfoModel.fromJson(item);
      areaList.add(trackAreaInfoModel);
      if (areaLineInfoList.length > 0) {
        areaLineInfoList.clear();
      }
      if (areaColumnInfoList.length > 0) {
        areaColumnInfoList.clear();
      }
      for (int i = 0; i < trackAreaInfoModel.area_lineSum; i++) {
        areaLineInfoList.add((i + 1).toString());
      }
      for (int i = 0; i < trackAreaInfoModel.area_columnSum; i++) {
        areaColumnInfoList.add((i + 1).toString());
      }
    }
    setState(() {});
  }

  void setTslTaskCarTrack() async {
    ///设置车厢所在库区
    setTslTaskCarTrackModel setTslTaskCarTrack = new setTslTaskCarTrackModel(
        Global.spUtil.getString(Constants.USERID).toString(),
        Global.spUtil.getString(Constants.USERCOMID).toString(),
        carInfo.car_number,
        carInfo.car_id,
        _loadLon,
        _loadLat,
        _loadAddress,
        addressSelectItemValue,
        areaListValue.area_name,
        areaListValue.area_id,
        int.parse(inOutInfoValue.toString()),
        int.parse(areaLineInfoValue.toString()),
        int.parse(areaColumnInfoValue.toString()),
        vehicleTypeInfoValue,
        inOutTypeInfoValue);

    final res = await HttpUtils.instance.post(
      Api.setTslTaskCarTrack,
      params: JsonUtil.setPostRequestParams(json.encode(setTslTaskCarTrack),
              Global.spUtil.getString(Constants.USERID).toString())
          .toJson(),
      tips: true,
    );
    carInfo = BasCarInfoModel.init();
    _carNumberController.text = "";
    setState(() {});
  }

  void getTeslaCarTrackByCarNumber(String car_id) async {
    ///根据车牌查询最新的跟踪记录
    getTeslaCarTrackByCarNumberModel getTeslaCarTrackByCarNumber =
        new getTeslaCarTrackByCarNumberModel(
            Global.spUtil.getString(Constants.USERID).toString(),
            Global.spUtil.getString(Constants.USERCOMID).toString(),
            car_id);
    final res = await HttpUtils.instance.post(
      Api.getTeslaCarTrackByCarNumber,
      params: JsonUtil.setPostRequestParams(
              json.encode(getTeslaCarTrackByCarNumber),
              Global.spUtil.getString(Constants.USERID).toString())
          .toJson(),
      tips: true,
    );
    carTrackInfoList.clear();
    for (var item in res.data) {
      TeslaCarTrackInfo carTrackInfo = TeslaCarTrackInfo.fromJson(item);
      carTrackInfoList.add(carTrackInfo);
    }
    if (carTrackInfoList.length > 0 &&
        addressModelList.length > 0 &&
        areaList.length > 0) {
      carTrackInfoListValue = TeslaCarTrackInfo.init();
      carTrackInfoListValue = carTrackInfoList[0];
      for (int i = 0; i < addressModelList.length; i++) {
        if (carTrackInfoListValue.teslact_locationType ==
            addressModelList[i].code) {
          addressSelectItemValue = addressModelList[i].code;
          break;
        }
      }
      for (int i = 0; i < areaList.length; i++) {
        if (carTrackInfoListValue.teslact_stoAreaId == areaList[i].area_id) {
          areaListValue = areaList[i];
          if (areaLineInfoList.length > 0) {
            areaLineInfoList.clear();
          }
          if (areaColumnInfoList.length > 0) {
            areaColumnInfoList.clear();
          }
          for (int i = 0; i < areaListValue.area_lineSum; i++) {
            areaLineInfoList.add((i + 1).toString());
          }
          for (int i = 0; i < areaListValue.area_columnSum; i++) {
            areaColumnInfoList.add((i + 1).toString());
          }
          for (int k = 0; k < areaLineInfoList.length; k++) {
            if (carTrackInfoListValue.teslact_line ==
                int.parse(areaLineInfoList[k])) {
              areaLineInfoValue = areaLineInfoList[k];
              break;
            }
          }
          for (int k = 0; k < areaColumnInfoList.length; k++) {
            if (carTrackInfoListValue.teslact_column ==
                int.parse(areaColumnInfoList[k])) {
              areaColumnInfoValue = areaColumnInfoList[k];
              break;
            }
          }
          break;
        }
      }
      for (int k = 0; k < vehicleTypeInfoList.length; k++) {
        if (carTrackInfoListValue.teslact_vehicleType ==
            vehicleTypeInfoList[k].code) {
          vehicleTypeInfoValue = vehicleTypeInfoList[k].code;
          vehicleTypeInfoValueName = vehicleTypeInfoList[k].name;
          break;
        }
      }
    }
    setState(() {});
  }

  void getCarInfoList(String carNumber) async {
    ///获取车厢停放位置类型
    getCarInfoListModel getCarInfoList;
    getCarInfoList = new getCarInfoListModel(
        Global.spUtil.getString(Constants.USERID).toString(),
        Global.spUtil.getString(Constants.USERCOMID).toString(),
        carNumber);
    final res = await HttpUtils.instance.post(
      Api.getCarInfoList,
      params: JsonUtil.setPostRequestParams(
              json.encode(getCarInfoList.toJson()),
              Global.spUtil.getString(Constants.USERID).toString())
          .toJson(),
      tips: true,
    );
    carInfoList.clear();
    for (var item in res.data) {
      BasCarInfoModel carInfoModel = BasCarInfoModel.fromJson(item);
      carInfoList.add(carInfoModel);
    }
    if (carInfoList.length > 0) {
      carNumberVisible = true;
    }
    setState(() {});
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

  /**
   * 列表的文字展示控件
   */
  Widget taskTextView2(String text) {
    return Expanded(
        flex: 1,
        child: Container(
          alignment: Alignment(0, 0),
          child: Text(
            text,
            style: TextStyle(color: Colors.lightBlue),
            textScaleFactor: 1.2,
          ),
        ));
  }

  /**
   * 列表的文字展示控件
   */
  Widget taskTextView3(String text) {
    return Expanded(
        flex: 2,
        child: Container(
          alignment: Alignment(0, 0),
          child: Text(
            text,
            style: TextStyle(color: Colors.lightBlue),
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
            value: addressSelectItemValue =
                list.length == 0 ? "0" : list[0].code,
          ),
          // 改变事件
          onChanged: (value) {
            addressSelectItemValue = value.toString();
            getTeslaCarTrackAreaInfoList(addressSelectItemValue);
            setState(() {});
          },
          value: addressSelectItemValue,
          // 图标大小
          iconSize: 24,
          // 下拉文本样式
          style: TextStyle(fontSize: 18.0, color: Colors.black54),
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
          value: vehicleTypeInfoValue = vehicleTypeInfoValue == null
              ? list.length == 0
                  ? null
                  : list[1].code
              : vehicleTypeInfoValue,

          ///使用3目运算初始化车厢类型
          // 图标大小
          iconSize: 24,
          // 下拉文本样式
          style: TextStyle(fontSize: 18.0, color: Colors.black54),
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
              if ("1" == inOutInfoValue) {
                inOutTypeInfoList = inOutTypeInfoList1;
              }
              if ("3" == inOutInfoValue) {
                inOutTypeInfoList = inOutTypeInfoList3;
              }
              inOutTypeInfoValue = inOutTypeInfoList[0].code;
            });
          },
          value: inOutInfoValue,
          // 图标大小
          iconSize: 24,
          // 下拉文本样式
          style: TextStyle(fontSize: 14.0, color: Colors.black54),
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
        child: DropdownButton<String>(
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
          style: TextStyle(fontSize: 14.0, color: Colors.black54),
        ),
      ),
    );
  }

  /**
   * 库区-行-下拉选择控件
   */
  Widget areaLineInfoTextView(List<String> list) {
    return Expanded(
      flex: 1,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          // 下拉列表的数据
          items: list.map<DropdownMenuItem<String>>((String e) {
            return DropdownMenuItem<String>(
              child: Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(e),
              ),
              value: e,
            );
          }).toList(),
          hint: DropdownMenuItem<String>(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(list.length == 0 ? "" : list[0]),
            ),
            value: list.length == 0 ? "0" : list[0],
          ),
          // 改变事件
          onChanged: (value) {
            setState(() {
              areaLineInfoValue = value.toString();
            });
          },
          value: areaLineInfoValue,
          // 图标大小
          iconSize: 24,
          // 下拉文本样式
          style: TextStyle(fontSize: 14.0, color: Colors.black54),
        ),
      ),
    );
  }

  /**
   * 库区-列-下拉选择控件
   */
  Widget areaColumnInfoTextView(List<String> list) {
    return Expanded(
      flex: 1,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          // 下拉列表的数据
          items: list.map<DropdownMenuItem<String>>((String e) {
            return DropdownMenuItem<String>(
              child: Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(e),
              ),
              value: e,
            );
          }).toList(),
          hint: DropdownMenuItem<String>(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(list.length == 0 ? "" : list[0]),
            ),
            value: list.length == 0 ? "0" : list[0],
          ),
          // 改变事件
          onChanged: (value) {
            setState(() {
              areaColumnInfoValue = value.toString();
            });
          },
          value: areaColumnInfoValue,
          // 图标大小
          iconSize: 24,
          // 下拉文本样式
          style: TextStyle(fontSize: 14.0, color: Colors.black54),
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
            controller: _carNumberController,
            decoration: InputDecoration(
              hintText: "请输入车厢号",
            ),
          ),
        ),
        InkWell(
          onTap: () {
            getCarInfoList(_carNumberController.text);
          },
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
        Visibility(
          visible: carInfo.car_trailerNumber == "" ? false : true,
          child: Container(
            height: 40,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                sizeBoxVertical(),
                taskTextView("集装箱号"),
                sizeBoxVertical(),
                taskTextView3(carInfo.car_trailerNumber),
                sizeBoxVertical(),
              ],
            ),
          ),
        ),
        sizeBoxLevel(),
        Container(
          height: 40,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              sizeBoxVertical(),
              taskTextView("所在场所"),
              sizeBoxVertical(),
              addressTypeTextView(addressModelList),
              sizeBoxVertical(),
            ],
          ),
        ),
        sizeBoxLevel(),
        Container(
          height: 40,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              sizeBoxVertical(),
              taskTextView("库区位置"),
              sizeBoxVertical(),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    taskTextView2(areaListValue == null
                        ? "选择库区"
                        : areaListValue.area_name),
                    sizeBoxVertical(),
                    areaLineInfoTextView(areaLineInfoList),
                    sizeBoxVertical(),
                    areaColumnInfoTextView(areaColumnInfoList),
                    sizeBoxVertical(),
                  ],
                ),
              ),
            ],
          ),
        ),
        sizeBoxLevel(),
        Container(
          height: 40,
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
          height: 40,
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

  Widget areaView(TslCarTrackAreaInfoModel item) {
    return InkWell(
      onTap: () {
        areaListValue = item;
        areaLineInfoValue = "1";
        areaColumnInfoValue = "1";
        for (TslCarTrackAreaInfoModel model in areaList) {
          model.area_isSelect = false;
        }
        item.area_isSelect = true;
        setState(() {});

        Fluttertoast.showToast(msg: item.area_name);
      },
      child: Container(
        //设置外边距
        margin: EdgeInsets.all(2),
        //设置内边距
        padding: EdgeInsets.only(top: 5),
        //设置 child 居中
        alignment: Alignment(0, 0),
        //边框设置
        decoration: new BoxDecoration(
          //背景
          color: item.area_isSelect == true ? Colors.lightBlue : Colors.white,
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          //设置四周边框
          border: new Border.all(width: 1, color: Colors.lightBlue),
        ),
        child: Column(children: [
          Text(
            item.area_name,
            style: TextStyle(
              color: item.area_isSelect == true ? Colors.white : Colors.black,
            ),
          ),
        ]),
      ),
    );
  }

  /**
   * 获取库区UI
   */
  List<Widget> _getAreaViewData() {
    ///调用获取库区数据方法
    List<Widget> list = [];
    for (TslCarTrackAreaInfoModel item in areaList) {
      list.add(areaView(item));
    }
    return list;
  }

  /**
   * 获取库区UI
   */
  Widget _areaViewData() {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,

        ///列数
        mainAxisSpacing: 2,

        ///主轴之间的间距
        crossAxisSpacing: 2,

        ///横轴之间的间距
        childAspectRatio: 2.0,

        ///设置宽高的比例 GridView的子组件直接设置宽高没有反应，可以通过childAspectRatio修改宽高
      ),
      children: this._getAreaViewData(),
    );
  }

  /**
   * 展示车辆列表信息
   */
  List<Widget> _getCarInfoListViewData() {
    List<Widget> list = [];
    print("开始渲染数据" + list.length.toString());
    for (BasCarInfoModel item in carInfoList) {
      list.add(_carInfoView(item));
    }

    return list;
  }

  Widget _carInfoView(BasCarInfoModel item) {
    return InkWell(
      onTap: () {
        // Fluttertoast.showToast(msg: item.car_number);
        _carNumberController.text = item.car_number;
        carInfo = item;
        carInfoList.clear();
        carNumberVisible = false;
        getTeslaCarTrackByCarNumber(item.car_id);
        setState(() {});
      },
      child: Container(
        //设置外边距
        margin: EdgeInsets.only(
          left: 1,
          top: 5,
          right: 1,
        ),
        //设置 child 居中
        alignment: Alignment(0, 0),
        //边框设置
        decoration: new BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周边框
          border: new Border.all(width: 1, color: Colors.grey),
        ),
        child: Row(
          children: [
            Expanded(
              ///Expanded 按比例占据空间
              flex: 1,
              child: Column(
                children: [
                  Container(
                    height: 30,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        taskTextView(item.car_number),
                      ],
                    ),
                  ),
                  sizeBoxLevel(),
                  Container(
                    height: 20,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        taskTextView(item.car_trailerNumber),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /**
   * 可变换禁用情况的按钮
   */
  Widget buttonView() {
    return MaterialButton(
      ///按钮的背景
      color: Colors.blue,
      child: Text("登记", style: TextStyle(color: Colors.white, fontSize: 16)),

      ///点击回调函数
      onPressed: () => _isButtonSubmit ? showDetailDialog() : null,

      ///按钮按下时回调 value = true
      ///按钮抬起时回调 value = false
      ///要先于 onPressed
      onHighlightChanged: (value) {
        _isButtonSubmit = true;
        if (_carNumberController.text.length <= 0) {
          Fluttertoast.showToast(msg: "请选择要登记的车厢车牌号");
          _isButtonSubmit = false;
          return;
        }
        if (_loadLon == 0 || _loadLat == 0) {
          Fluttertoast.showToast(msg: "定位地址为空！");
          _isButtonSubmit = false;
          return;
        }
        if (carInfo.car_id == null || carInfo.car_id == "") {
          Fluttertoast.showToast(msg: "请选择要登记的车厢车牌号");
          _isButtonSubmit = false;
          return;
        }
        if (addressSelectItemValue == null) {
          Fluttertoast.showToast(msg: "请选择所在场所");
          _isButtonSubmit = false;
          return;
        } else {
          for (TslTypeModel model in addressModelList) {
            if (model.code == addressSelectItemValue) {
              addressTypeCodeName = model.name;
              break;
            }
          }
        }
        if (vehicleTypeInfoValue == null) {
          Fluttertoast.showToast(msg: "请选择车厢类型");
          _isButtonSubmit = false;
          return;
        } else {
          for (TslTypeModel model in vehicleTypeInfoList) {
            if (model.code == vehicleTypeInfoValue) {
              vehicleTypeInfoValueName = model.name;
              break;
            }
          }
        }
        if (areaListValue.area_id == null || areaListValue.area_id == "") {
          Fluttertoast.showToast(msg: "请选择要停放的库区");
          _isButtonSubmit = false;
          return;
        }
        if (areaLineInfoValue == null || areaLineInfoValue == 0) {
          Fluttertoast.showToast(msg: "请选择停放的行数");
          _isButtonSubmit = false;
          return;
        }
        if (areaColumnInfoValue == null || areaColumnInfoValue == 0) {
          Fluttertoast.showToast(msg: "请选择停放的列数");
          _isButtonSubmit = false;
          return;
        }
        if (inOutInfoValue == null || "" == inOutInfoValue) {
          Fluttertoast.showToast(msg: "请选择进入/离开");
          _isButtonSubmit = false;
          return;
        }
        if (inOutTypeInfoValue == null || "" == inOutTypeInfoValue) {
          Fluttertoast.showToast(msg: "请选择进出类型");
          _isButtonSubmit = false;
          return;
        } else {
          for (TslTypeModel model in inOutTypeInfoList) {
            if (model.code == inOutTypeInfoValue) {
              inOutTypeInfoValueName = model.name;
              break;
            }
          }
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
      highlightColor: Colors.deepPurple,

      ///水波方的颜色
      splashColor: Colors.green,

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
      minWidth: 200,
    );
  }

  /**
   * 登记提交弹窗
   */
  showDetailDialog() {
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('提示'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text("车牌：" +
                    carInfo.car_number +
                    "(" +
                    vehicleTypeInfoValueName +
                    ")"),
                new Text("集装箱号：" + carInfo.car_trailerNumber),
                new Text(
                  "因：" +
                      inOutTypeInfoValueName +
                      (inOutInfoValue == "1" ? " 进入" : " 离开"),
                  style: TextStyle(color: Colors.red),
                ),
                new Text(
                  addressTypeCodeName +
                      " : " +
                      areaListValue.area_name +
                      "-" +
                      areaLineInfoValue +
                      "-" +
                      areaColumnInfoValue,
                  style: TextStyle(color: Colors.blue),
                ),
                new Text("即将提交登记信息，请谨慎操作！确认提交？"),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('确定'),
              onPressed: () {
                setTslTaskCarTrack();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((val) {
      print(val);
    });
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
            Visibility(
              visible: carNumberVisible,
              maintainSize: false,
              child: Expanded(
                child: ListView(
                  children: this._getCarInfoListViewData(),
                ),
              ),
            ),
            Visibility(
              visible: !carNumberVisible,
              maintainSize: false,
              child: carriageView(),
            ),
            Visibility(
              visible: !carNumberVisible,
              maintainSize: false,
              child: Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: _areaViewData(),
                ),
              ),
            ),
            buttonView(),
          ],
        ),
      ),
    );
  }
}
