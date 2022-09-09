/**
 * FileName TslTypeModel
 * @Author lilong.chen
 * @Date 2022/7/20 11:04
 */

class TslTypeModel{
  /**
   * 编码
   */
  late String code;
  /**
   * 名称
   */
  late String name;


  TslTypeModel(this.code,this.name);


  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
    'code': this.code,
    'name' :this.name,
  };


  factory TslTypeModel.fromJson(Map<String, dynamic> jsonStr) {
    return TslTypeModel(
        jsonStr['code'],
        jsonStr['name'],
    );
  }

  String toString() {
    return name;
  }



}