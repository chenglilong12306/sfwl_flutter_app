
import 'dart:collection';

class JSONObject{

  late String userKey;
  late String content;
  late String timeSpan;
  late String sign;
  late String dataType;


   JSONObject(String userKey,String content,String timeSpan,String sign,String dataType){
     this.userKey = userKey;
     this.content = content;
     this.timeSpan = timeSpan;
     this.sign = sign;
     this.dataType = dataType;
   }

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map toJson() {
    Map map = new Map();
    map["userKey"] = this.userKey;
    map["content"] = this.content;
    map["timeSpan"] = this.timeSpan;
    map["sign"] = this.sign;
    map["dataType"] = this.dataType;
    return map;
  }
  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  HashMap toJsonV2() {
    HashMap map = new HashMap();
    map["userKey"] = this.userKey;
    map["content"] = this.content;
    map["timeSpan"] = this.timeSpan;
    map["sign"] = this.sign;
    map["dataType"] = this.dataType;
    return map;
  }
  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJsonV3() {
    Map<String, dynamic> map = new HashMap();
    map["userKey"] = this.userKey;
    map["content"] = this.content;
    map["timeSpan"] = this.timeSpan;
    map["sign"] = this.sign;
    map["dataType"] = this.dataType;
    return map;
  }


}