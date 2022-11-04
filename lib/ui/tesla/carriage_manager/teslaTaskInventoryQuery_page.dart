import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../Constants.dart';
import '../../../Global.dart';
import '../../../common/net/Api.dart';
import '../../../common/net/Dio_utils.dart';
import '../../../common/utils/JsonUtil.dart';
import '../../../model/TslCarTrackAreaInfoModel.dart';
import '../../../model/TslTypeModel.dart';
import '../../../model/request/getInventoryQueryListByLocationTypeModel.dart';
import '../../../model/request/getTeslaCarTrackAreaInfoModel.dart';
import '../../../model/request/getTslTransportTaskListModel.dart';

/**
 * FileName 特斯拉项目管理--库存查询
 * @Author lilong.chen
 * @Date 2022/7/18 15:55
 */

class TeslaTaskInventoryQueryPage extends StatefulWidget {
  TeslaTaskInventoryQueryPage({Key? super.key});

  @override
  TeslaTaskInventoryQueryPageState createState() =>
      TeslaTaskInventoryQueryPageState();
}

class TeslaTaskInventoryQueryPageState
    extends State<TeslaTaskInventoryQueryPage>
    with
        AutomaticKeepAliveClientMixin<TeslaTaskInventoryQueryPage>,
        WidgetsBindingObserver {
  /**车厢停放位置 -- 所在场所*/
  var addressSelectItemValue = "tcc";
  var addressTypeCodeName;
  var area_StoAreaSumCar = 0;
  List<TslTypeModel> addressModelList = <TslTypeModel>[];

  /**库区列表*/
  List<TslCarTrackAreaInfoModel> areaList = <TslCarTrackAreaInfoModel>[];
  late TslCarTrackAreaInfoModel areaListValue = TslCarTrackAreaInfoModel.init();

  @override
  void initState() {
    getTslNewAddressTypeInfo();
    getInventoryQueryListByLocationType(addressSelectItemValue);
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
    getInventoryQueryListByLocationTypeModel getInventoryQueryListByLocationType;
    getInventoryQueryListByLocationType = new getInventoryQueryListByLocationTypeModel(
        area_locationType,
        Global.spUtil.getString(Constants.USERID).toString(),
        Global.spUtil.getString(Constants.USERCOMID).toString());
    final res = await HttpUtils.instance.post(
      Api.getInventoryQueryListByLocationType,
      params: JsonUtil.setPostRequestParams(json.encode(getInventoryQueryListByLocationType.toJson()),
              Global.spUtil.getString(Constants.USERID).toString())
          .toJson(),
      tips: true,
    );
    areaList.clear();
    area_StoAreaSumCar = 0;
    for (var item in res.data) {
      TslCarTrackAreaInfoModel trackAreaInfoModel = TslCarTrackAreaInfoModel.fromJson(item);
      area_StoAreaSumCar += trackAreaInfoModel.area_StoAreaSum;
      areaList.add(trackAreaInfoModel);
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

  /**
   * 列表的文字展示控件
   */
  Widget taskTextView4(String text) {
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
      flex: 1,
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
            getInventoryQueryListByLocationType(addressSelectItemValue);
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

  Widget carriageView() {
    return Column(
      children: [
        sizeBoxLevel(),
        Container(
          height: 40,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              sizeBoxVertical(),
              addressTypeTextView(addressModelList),
              sizeBoxVertical(),
              taskTextView3("总 "+area_StoAreaSumCar.toString() +" 辆"),
              sizeBoxVertical(),
            ],
          ),
        ),
        sizeBoxLevel(),
      ],
    );
  }

  /**
   * 获取库区UI
   */
  Widget _areaViewData() {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        ///列数
        crossAxisCount: 2,

        ///主轴之间的间距
        mainAxisSpacing: 10,

        ///横轴之间的间距
        crossAxisSpacing: 2,

        ///设置宽高的比例 GridView的子组件直接设置宽高没有反应，可以通过childAspectRatio修改宽高
        childAspectRatio: 4.0,
      ),
      children: this._getAreaViewData(),
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

  Widget areaView(TslCarTrackAreaInfoModel item) {
    return InkWell(
      onTap: () {
        areaListValue = item;
        setState(() {});
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
        child: Row(children: [
          taskTextView(item.area_name),
          sizeBoxVertical(),
          taskTextView4(item.area_StoAreaSum.toString()),
        ]),
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
            carriageView(),
            Visibility(
              visible: areaList.length > 0,
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