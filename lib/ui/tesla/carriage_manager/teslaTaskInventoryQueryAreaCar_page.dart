import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sfwl_flutter_app/common/utils/DateTimeUitl.dart';
import 'package:sfwl_flutter_app/model/TeslaCarTrackInfoModel.dart';

import '../../../Constants.dart';
import '../../../Global.dart';
import '../../../common/net/Api.dart';
import '../../../common/net/Dio_utils.dart';
import '../../../common/utils/JsonUtil.dart';
import '../../../common/widget/base_tabbar_widget.dart';
import '../../../model/TeslaCarTrackDetailInfoModel.dart';
import '../../../model/TslCarTrackAreaInfoModel.dart';
import '../../../model/TslTypeModel.dart';
import '../../../model/request/getInventoryQueryListByLocationTypeModel.dart';
import '../../../model/request/getInventoryQueryListAreaDetailsModel.dart';
import '../../../model/request/getInventoryQueryListCarDetailsModel.dart';
import '../../../model/request/getTslTransportTaskListModel.dart';
import 'teslaTaskCarriageManager_page.dart';
import 'teslaTaskInventoryQuery_page.dart';

/**
 * FileName 特斯拉车厢管理--车厢详情
 * @Author lilong.chen
 * @Date 2022/11/4 13:55
 */

class TeslaTaskInventoryQueryAreaCarPage extends StatefulWidget {
  final TeslaCarTrackInfoModel carTrackInfo;

  TeslaTaskInventoryQueryAreaCarPage(this.carTrackInfo, {Key? super.key});

  @override
  TeslaTaskInventoryQueryAreaCarPageState createState() =>
      TeslaTaskInventoryQueryAreaCarPageState(carTrackInfo);
}

class TeslaTaskInventoryQueryAreaCarPageState
    extends State<TeslaTaskInventoryQueryAreaCarPage>
    with
        AutomaticKeepAliveClientMixin<TeslaTaskInventoryQueryAreaCarPage>,
        WidgetsBindingObserver {
  late final TeslaCarTrackInfoModel carTrackInfo;

  TeslaTaskInventoryQueryAreaCarPageState(this.carTrackInfo);

  /**特斯拉车厢跟踪明细表列表*/
  List<TeslaCarTrackDetailInfoModel> carTrackDetailInfoList = <TeslaCarTrackDetailInfoModel>[];

  @override
  void initState() {
    getInventoryQueryListCarDetails(carTrackInfo.teslact_carid);
    super.initState();
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
              "操作时间",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          sizeBoxVertical(),
          Expanded(
            flex: 1,
            child: Text(
              "动作",
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
              "库区位置",
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

  void getInventoryQueryListCarDetails(String car_id) async {
    ///查询车厢库存情况
    getInventoryQueryListCarDetailsModel getInventoryQueryListCarDetails;
    getInventoryQueryListCarDetails = new getInventoryQueryListCarDetailsModel(
        car_id,
        Global.spUtil.getString(Constants.USERID).toString(),
        Global.spUtil.getString(Constants.USERCOMID).toString());
    final res = await HttpUtils.instance.post(
      Api.getInventoryQueryListCarDetails,
      params: JsonUtil.setPostRequestParams(
              json.encode(getInventoryQueryListCarDetails.toJson()),
              Global.spUtil.getString(Constants.USERID).toString())
          .toJson(),
      tips: true,
    );
    if (res.data.toString().length > 0) {
      carTrackDetailInfoList.clear();
    }
    for (var item in res.data) {
      TeslaCarTrackDetailInfoModel carTrackInfo = TeslaCarTrackDetailInfoModel.fromJson(item);
      carTrackDetailInfoList.add(carTrackInfo);
    }
    setState(() {});
  }

  List<Widget> _getListViewData() {
    List<Widget> list = [];
    print("开始渲染数据" + list.length.toString());
    for (TeslaCarTrackDetailInfoModel item in carTrackDetailInfoList) {
      list.add(listItemView(item));
    }

    return list;
  }

  Widget listItemView(TeslaCarTrackDetailInfoModel item) {

    var stoAddress = "";
    if (item.tctd_locationType == "tcc") {
      stoAddress = "停：" +
          item.tctd_stoAreaName +
          "-" +
          item.tctd_line.toString() +
          "-" +
          item.tctd_column.toString();
    } else if (item.tctd_locationType == "dc") {
      stoAddress = "堆：" +
          item.tctd_stoAreaName +
          "-" +
          item.tctd_line.toString() +
          "-" +
          item.tctd_column.toString();
    }

    return Column(
      children: [
        Container(
          color: Colors.white,
          constraints: BoxConstraints(minHeight: 40),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  DateTimeUtil.getDateTimeSwitchString(
                      DateTimeUtil.getTimeStampSwitchDateTime(
                          int.parse(item.tctd_trackTime.toString())),
                      DateTimeUtil.YYYY_MM_DD_HH_MM_SS),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.lightBlue,
                  ),
                ),
              ),
              sizeBoxVertical(),
              Expanded(
                flex: 1,
                child: Text(
                  item.tctd_action.toString() == "1" ? "进入" : "离开",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              sizeBoxVertical(),
              Expanded(
                flex: 2,
                child: Text(
                  item.tctd_vehicleType,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              sizeBoxVertical(),
              Expanded(
                flex: 2,
                child: Text(
                  stoAddress,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              sizeBoxVertical(),
              Expanded(
                flex: 2,
                child: Text(
                  item.tctd_inOutType,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        sizeBoxLevel(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("车厢详情"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            height: 40,
            child: Text(
              "车牌号码：" + carTrackInfo.teslact_carNumber,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize:18,color: Colors.lightBlue),
            ),
          ),
          sizeBoxLevel(),
          Visibility(
            visible: carTrackInfo.car_trailerNumber != "" ? true : false,
            child: Container(
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              height: 40,
              child: Text(
                "集装箱号：" + carTrackInfo.car_trailerNumber,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize:18,color: Colors.black38),
              ),
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
