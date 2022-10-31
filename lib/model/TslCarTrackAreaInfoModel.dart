/**
 * FileName TslCarTrackAreaInfo
 * @Author lilong.chen
 * @Date 2022/10/28 16:32
 * 特斯拉库区表model
 */

class TslCarTrackAreaInfoModel{

  /**
   * ID
   */
  late String area_id;

  /**
   * 位置类型  可选值：dc = 堆场；tcc = 停车场；
   */
  late String area_locationType;

  /**
   * 库区名称
   */
  late String area_name;

  /**
   * 创建时间
   */
  late num area_addtime;

  /**
   * 创建人  系统初始化，默认系统管理员：00000000-0000-0000-0000-000000000000
   */
  late String area_addUserId;

  /**
   * 修改人
   */
  late String area_modifyUserId;

  /**
   * 修改时间
   */
  late num area_modifyTime;

  /**
   * 序号
   */
  late int area_serialNumber;
  /**
   * 存放此库区的总行数
   */
  late int area_lineSum;

  /**
   * 存放此库区总列数
   */
  late int area_columnSum;

  /**
   * 库区存储车厢总数
   */
  late int area_StoAreaSum;

  TslCarTrackAreaInfoModel(
      this.area_id,
      this.area_locationType,
      this.area_name,
      this.area_addtime,
      this.area_addUserId,
      this.area_modifyUserId,
      this.area_modifyTime,
      this.area_serialNumber,
      this.area_lineSum,
      this.area_columnSum,
      this.area_StoAreaSum
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'area_id': this.area_id,
    'area_locationType': this.area_locationType,
    'area_name': this.area_name,
    'area_addtime': this.area_addtime,
    'area_addUserId': this.area_addUserId,
    'area_modifyUserId': this.area_modifyUserId,
    'area_modifyTime': this.area_modifyTime,
    'area_serialNumber': this.area_serialNumber,
    'area_lineSum': this.area_lineSum,
    'area_columnSum': this.area_columnSum,
    'area_StoAreaSum': this.area_StoAreaSum
  };


  factory TslCarTrackAreaInfoModel.fromJson(Map<String, dynamic> jsonStr) {
    return TslCarTrackAreaInfoModel(
        jsonStr['area_id'],
        jsonStr['area_locationType'],
        jsonStr['area_name'] != null ? jsonStr['area_name'] : "",
        jsonStr['area_addtime'],
        jsonStr['area_addUserId'],
        jsonStr['area_modifyUserId'] != null ? jsonStr['area_modifyUserId'] : "",
        jsonStr['area_modifyTime'],
        jsonStr['area_serialNumber'],
        jsonStr['area_lineSum'] != null ? jsonStr['area_lineSum'] : "",
        jsonStr['area_columnSum'] != null ? jsonStr['area_columnSum'] : "",
        jsonStr['area_StoAreaSum']);
  }

}