/**
 * FileName BasCarInfoModel  车辆信息
 * @Author lilong.chen
 * @Date 2022/11/1 11:04
 */

class BasCarInfoModel {
  /**
   *车辆ID
   */
  late String car_id;

  /**
   *运营机构
   */
  late String car_TranComid;

  /**
   *车牌号码
   */
  late String car_number;

  /**
   *车辆分类
   */
  late String car_class;

  /**
   *车辆类型
   */
  late String car_type;

  /**
   *是否自车
   */
  late String car_isHaving;

  /**
   *主驾驶ID
   */
  late String car_driid;

  /**
   *运输类型
   */
  late String car_TranType;

  /**
   *禁用
   */
  late String car_isDisabled;

  /**
   *是否自车外用
   */
  late String car_isHavingOut;

  /**
   *集装箱号
   */
  late String car_trailerNumber;

  BasCarInfoModel(
    this.car_id,
    this.car_TranComid,
    this.car_number,
    this.car_class,
    this.car_type,
    this.car_isHaving,
    this.car_driid,
    this.car_TranType,
    this.car_isDisabled,
    this.car_isHavingOut,
    this.car_trailerNumber,
  );

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
        'car_id': this.car_id,
        'car_TranComid': this.car_TranComid,
        'car_number': this.car_number,
        'car_class': this.car_class,
        'car_type': this.car_type,
        'car_isHaving': this.car_isHaving,
        'car_driid': this.car_driid,
        'car_TranType': this.car_TranType,
        'car_isDisabled': this.car_isDisabled,
        'car_isHavingOut': this.car_isHavingOut,
        'car_trailerNumber': this.car_trailerNumber,
      };

  factory BasCarInfoModel.fromJson(Map<String, dynamic> jsonStr) {
    return BasCarInfoModel(
      jsonStr['car_id'],
      jsonStr['car_TranComid'],
      jsonStr['car_number'],
      jsonStr['car_class'],
      jsonStr['car_type'],
      jsonStr['car_isHaving'],
      jsonStr['car_driid'],
      jsonStr['car_TranType'],
      jsonStr['car_isDisabled'],
      jsonStr['car_isHavingOut'],
      jsonStr['car_trailerNumber'] != null ? jsonStr['car_trailerNumber'] : "",
    );
  }
}
