import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sfwl_flutter_app/common/utils/DateTimeUitl.dart';
import 'package:sfwl_flutter_app/model/TeslaCarTrackInfoModel.dart';
import 'package:sfwl_flutter_app/ui/tesla/carriage_manager/teslaTaskInventoryQueryAreaCar_page.dart';

import '../../../Constants.dart';
import '../../../Global.dart';
import '../../../common/net/Api.dart';
import '../../../common/net/Dio_utils.dart';
import '../../../common/utils/JsonUtil.dart';
import '../../../common/widget/base_tabbar_widget.dart';
import '../../../model/TslCarTrackAreaInfoModel.dart';
import '../../../model/TslTypeModel.dart';
import '../../../model/request/getInventoryQueryListByLocationTypeModel.dart';
import '../../../model/request/getInventoryQueryListAreaDetailsModel.dart';
import '../../../model/request/getTslTransportTaskListModel.dart';
import 'teslaTaskCarriageManager_page.dart';
import 'teslaTaskInventoryQuery_page.dart';

/**
 * FileName 特斯拉车厢管理--库区详情
 * @Author lilong.chen
 * @Date 2022/11/4 13:55
 */

class TeslaTaskInventoryQueryAreaPage extends StatefulWidget {
  final TslCarTrackAreaInfoModel areaInfo;

  TeslaTaskInventoryQueryAreaPage(this.areaInfo, {Key? super.key});

  @override
  TeslaTaskInventoryQueryAreaPageState createState() =>
      TeslaTaskInventoryQueryAreaPageState(areaInfo);
}

class TeslaTaskInventoryQueryAreaPageState
    extends State<TeslaTaskInventoryQueryAreaPage>
    with
        AutomaticKeepAliveClientMixin<TeslaTaskInventoryQueryAreaPage>,
        WidgetsBindingObserver {
  late final TslCarTrackAreaInfoModel areaInfo;

  TeslaTaskInventoryQueryAreaPageState(this.areaInfo);

  /**车厢停放位置 -- 所在场所*/
  var addressSelectItemValue = "tcc";
  var addressTypeCodeName;
  var area_StoAreaSumCar = 0;
  List<TslTypeModel> addressModelList = <TslTypeModel>[];

  /**库区列表*/
  List<TslCarTrackAreaInfoModel> areaList = <TslCarTrackAreaInfoModel>[];
  var areaListCode;

  /**特斯拉车厢跟踪主表列表*/
  List<TeslaCarTrackInfoModel> carTrackInfoList = <TeslaCarTrackInfoModel>[];

  @override
  void initState() {
    getTslNewAddressTypeInfo();
    getInventoryQueryListByLocationType(addressSelectItemValue);
    getDateList(areaInfo.area_locationType, areaInfo.area_id);
    super.initState();
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

  void getInventoryQueryListByLocationType(String area_locationType) async {
    ///获取车厢停放位置类型
    getInventoryQueryListByLocationTypeModel
        getInventoryQueryListByLocationType;
    getInventoryQueryListByLocationType =
        new getInventoryQueryListByLocationTypeModel(
            area_locationType,
            Global.spUtil.getString(Constants.USERID).toString(),
            Global.spUtil.getString(Constants.USERCOMID).toString());
    final res = await HttpUtils.instance.post(
      Api.getInventoryQueryListByLocationType,
      params: JsonUtil.setPostRequestParams(
              json.encode(getInventoryQueryListByLocationType.toJson()),
              Global.spUtil.getString(Constants.USERID).toString())
          .toJson(),
      tips: true,
    );
    areaList.clear();
    area_StoAreaSumCar = 0;
    for (var item in res.data) {
      TslCarTrackAreaInfoModel trackAreaInfoModel =
          TslCarTrackAreaInfoModel.fromJson(item);
      area_StoAreaSumCar += trackAreaInfoModel.area_StoAreaSum;
      areaList.add(trackAreaInfoModel);
    }
    for (int i = 0; i < areaList.length; i++) {
      if (areaInfo.area_id == areaList[i].area_id) {
        areaListCode = areaList[i].area_id;
        break;
      }
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
              addressSelectItemValue = value.toString();
              getInventoryQueryListByLocationType(addressSelectItemValue);
              if (areaList.length > 0) {
                areaListCode = areaList[0].area_id;
              }
            });
          },
          value: addressSelectItemValue,
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
  Widget inOutInfoValueTextView(List<TslCarTrackAreaInfoModel> list) {
    return Expanded(
      flex: 2,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          // 下拉列表的数据
          items:
              list.map<DropdownMenuItem<String>>((TslCarTrackAreaInfoModel e) {
            return DropdownMenuItem<String>(
              child: Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(e.area_name),
              ),
              value: e.area_id,
            );
          }).toList(),
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
              areaListCode = value.toString();
              getDateList(addressSelectItemValue, areaListCode);
            });
          },
          value: areaListCode,
          // 图标大小
          iconSize: 24,
          // 下拉文本样式
          style: TextStyle(fontSize: 14.0, color: Colors.black54),
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
   * 列表标题栏View
   */
  Widget listTitleView() {
    return Container(
      height: 50,
      color: Colors.blue,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "车牌",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          sizeBoxVertical(),
          Expanded(
            flex: 1,
            child: Text(
              "位置",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          sizeBoxVertical(),
          Expanded(
            flex: 2,
            child: Text(
              "类型",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          sizeBoxVertical(),
          Expanded(
            flex: 2,
            child: Text(
              "操作时间",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          sizeBoxVertical(),
          Expanded(
            flex: 2,
            child: Text(
              "进出类型",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void getDateList(String addressSelectItemValue, String areaListCode) async {
    ///正向单据任务请求
    getInventoryQueryListAreaDetailsModel getInventoryQueryListAreaDetails;
    getInventoryQueryListAreaDetails =
        new getInventoryQueryListAreaDetailsModel(
      Global.spUtil.getString(Constants.USERID).toString(),
      Global.spUtil.getString(Constants.USERCOMID).toString(),
      addressSelectItemValue,
      areaListCode,
    );
    final res = await HttpUtils.instance.post(
      Api.getInventoryQueryListAreaDetails,
      params: JsonUtil.setPostRequestParams(
              json.encode(getInventoryQueryListAreaDetails.toJson()),
              Global.spUtil.getString(Constants.USERID).toString())
          .toJson(),
      tips: true,
    );
    if (res.data.toString().length > 0) {
      carTrackInfoList.clear();
    }
    for (var item in res.data) {
      TeslaCarTrackInfoModel carTrackInfo = TeslaCarTrackInfoModel.fromJson(item);
      carTrackInfoList.add(carTrackInfo);
    }
    setState(() {});
  }

  List<Widget> _getListViewData() {
    List<Widget> list = [];
    print("开始渲染数据" + list.length.toString());
    for (TeslaCarTrackInfoModel item in carTrackInfoList) {
      list.add(listItemView(item));
    }

    return list;
  }

  Widget listItemView(TeslaCarTrackInfoModel item) {
    var timeInterval = DateTimeUtil.dateDiffHours(
        DateTimeUtil.getTimeStampSwitchDateTime(
            int.parse(item.teslact_latestTime.toString())),
        DateTimeUtil.getDateTimeNew());
    return InkWell(
      onTap: () {
        ///跳转特斯拉项目--车厢管理--车厢详情
        ///带返回刷新数据的跳转
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TeslaTaskInventoryQueryAreaCarPage(item)))
            .then((value) => getDateList(addressSelectItemValue, areaListCode));
        setState(() {});
      },
      child: Column(
        children: [
          Container(
            color: Colors.white,
            constraints: BoxConstraints(minHeight: 40),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        item.teslact_carNumber,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                      Visibility(
                        visible: item.teslact_carNumber != "",
                        child: Text(
                          item.car_trailerNumber,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                sizeBoxVertical(),
                Expanded(
                  flex: 1,
                  child: Text(
                    item.teslact_line.toString() +
                        "-" +
                        item.teslact_column.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                sizeBoxVertical(),
                Expanded(
                  flex: 2,
                  child: Text(
                    item.teslact_vehicleType,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                sizeBoxVertical(),
                Expanded(
                  flex: 2,
                  child: Text(
                    DateTimeUtil.getDateTimeSwitchString(
                        DateTimeUtil.getTimeStampSwitchDateTime(
                            int.parse(item.teslact_latestTime.toString())),
                        DateTimeUtil.YYYY_MM_DD_HH_MM_SS),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: timeInterval > 48 ? Colors.red : Colors.lightBlue,
                    ),
                  ),
                ),
                sizeBoxVertical(),
                Expanded(
                  flex: 2,
                  child: Text(
                    item.teslact_inOutType,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          sizeBoxLevel(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("库区详情"),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            child: Row(
              children: [
                inOutInfoTextView(addressModelList),
                sizeBoxLevel(),
                inOutInfoValueTextView(areaList),
              ],
            ),
          ),
          listTitleView(),
          Expanded(
            child: ListView(
              children: this._getListViewData(),
            ),
          ),
        ],
      ),
    );
  }
}
