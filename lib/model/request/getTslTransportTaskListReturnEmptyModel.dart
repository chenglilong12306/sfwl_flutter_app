/**
 * 获取返空运输任务列表model
 */
class getTslTransportTaskListReturnEmptyModel {
  late String driverId;
  late String comId;
  late String startTime;
  late String endTime;


  getTslTransportTaskListReturnEmptyModel(this.driverId,this.comId,this.startTime,this.endTime);

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
     'driverId': this.driverId,
     'comId': this.comId,
     'startTime': this.startTime,
     'endTime': this.endTime,
  };

  factory getTslTransportTaskListReturnEmptyModel.fromJson(Map<String, dynamic> json) {
    return getTslTransportTaskListReturnEmptyModel(json['driverId'],json['comId'],json['startTime'],json['endTime']);
  }


}
