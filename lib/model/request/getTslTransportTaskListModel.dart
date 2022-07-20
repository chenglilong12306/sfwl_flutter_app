/**
 * 获取运输任务列表model
 */
class getTslTransportTaskListModel {
  late String driverId;
  late String comId;


  getTslTransportTaskListModel(this.driverId,this.comId);

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
     'driverId': this.driverId,
     'comId': this.comId,
  };

  factory getTslTransportTaskListModel.fromJson(Map<String, dynamic> json) {
    return getTslTransportTaskListModel(json['driverId'],json['comId']);
  }


}
