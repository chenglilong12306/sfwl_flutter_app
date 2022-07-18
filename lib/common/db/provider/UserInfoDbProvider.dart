import 'dart:async';

import 'package:sfwl_flutter_app/common/utils/code_utils.dart';
import 'package:sfwl_flutter_app/model/UserInfoModel.dart';
import 'package:sqflite/sqflite.dart';

import '../sql_provider.dart';

/**
 * 用户表
 * Created by lilong.chen
 * Date: 2022-07-12
 */

class UserInfoDbProvider extends BaseDbProvider {
  final String name = 'UserInfo';

  final String columnId = "_id";

  int? id;
  String? user_app_pwd;
  String? user_cityname;
  String? user_comid;
  String? user_comname;
  String? user_id;
  String? user_isBingdingPhone;
  String? user_name;
  String? user_pwd;
  String? user_subid;
  String? user_subname;
  String? user_type;
  String? user_uid;

  UserInfoDbProvider();

  Map<String, dynamic> toMap(String eventMapString) {
    Map<String, dynamic> map = CodeUtils.decodeMapResult(eventMapString);
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  UserInfoDbProvider.fromMap(Map map) {
    id = map[columnId];
    user_app_pwd = map["user_app_pwd"];
    user_cityname = map["user_cityname"];
    user_comid = map["user_comid"];
    user_comname = map["user_comname"];
    user_id = map["user_id"];
    user_isBingdingPhone = map["user_isBingdingPhone"];
    user_name = map["user_name"];
    user_pwd = map["user_pwd"];
    user_subid = map["user_subid"];
    user_subname = map["user_subname"];
    user_type = map["user_type"];
    user_uid = map["user_uid"];
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
        user_app_pwd text not null
        ,user_cityname text not null
        ,user_comid text not null
        ,user_comname text not null
        ,user_id text not null
        ,user_isBingdingPhone text not null
        ,user_name text not null
        ,user_pwd text not null
        ,user_subid text not null
        ,user_subname text not null
        ,user_type text not null
        ,user_uid text not null
        )
      ''';
  }

  @override
  tableName() {
    return name;
  }

  Future _getUserProvider(Database db, String? user_id) async {
    List<Map<String, dynamic>> maps = await db.query(name,
        columns: [columnId, "user_app_pwd", "user_cityname", "user_comid",
          "user_comname", "user_id", "user_isBingdingPhone", "user_name",
          "user_pwd", "user_subid", "user_subname", "user_type", "user_uid"],
        where: "user_id = ?",
        whereArgs: [user_id]);
    if (maps.length > 0) {
      UserInfoDbProvider provider = UserInfoDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  ///插入到数据库
  Future insert(String user_id, String eventMapString) async {
    Database db = await getDataBase();
    var userProvider = await _getUserProvider(db, user_id);
    if (userProvider != null) {
      await db
          .delete(name, where: "user_id = ?", whereArgs: [user_id]);
    }
    return await db.insert(name, toMap(eventMapString));
  }

  ///通过user_id更新用户数据
  Future update(String user_id, String eventMapString) async {
    Database db = await getDataBase();
    return await db.update(name, toMap(eventMapString));
  }

  ///通过user_id获取用户数据
  Future<UserInfoModel?> getUserInfo(String? user_id) async {
    Database db = await getDataBase();
    var provider = await _getUserProvider(db, user_id);
    if (provider != null) {
      UserInfoModel userInfoModel = new UserInfoModel(provider.user_app_pwd, provider.user_cityname,
          provider.user_comid, provider.user_comname, provider.user_id,
          bool.hasEnvironment(provider.user_isBingdingPhone), provider.user_name, provider.user_pwd,
          provider.user_subid, provider.user_subname, provider.user_type, provider.user_uid);
      return userInfoModel;
    }
    return null;
  }

}
