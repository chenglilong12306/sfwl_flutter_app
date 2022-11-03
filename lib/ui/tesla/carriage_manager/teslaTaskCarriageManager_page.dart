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
  TextEditingController _carNumberController = TextEditingController();
  var carNumberVisible = false;

  /**库区列表*/
  List<BasCarInfoModel> carInfoList = <BasCarInfoModel>[];
  var carInfo;

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

  /**车厢停放位置*/
  var addressSelectItemValue = "tcc";
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
    carTrackInfoListValue = TeslaCarTrackInfo.init();
    areaLineInfoValue = "1";
    areaColumnInfoValue = "1";
    for (var item in res.data) {
      TeslaCarTrackInfo carTrackInfo = TeslaCarTrackInfo.fromJson(item);
      carTrackInfoList.add(carTrackInfo);
    }
    if (carTrackInfoList.length > 0 &&
        addressModelList.length > 0 &&
        areaList.length > 0) {
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
            value: list.length == 0 ? "0" : list[0].code,
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
          style: TextStyle(fontSize: 14.0, color: Colors.grey),
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
          style: TextStyle(fontSize: 14.0, color: Colors.grey),
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
          visible: carTrackInfoListValue.car_trailerNumber == "" ? false : true,
          child:Container(
            height: 50,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                sizeBoxVertical(),
                taskTextView("集装箱号"),
                sizeBoxVertical(),
                taskTextView3(carTrackInfoListValue.car_trailerNumber),
                sizeBoxVertical(),
              ],
            ),
          ),
        ),
        sizeBoxLevel(),
        Container(
          height: 50,
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
          height: 50,
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
          ],
        ),
      ),
    );
  }
}
