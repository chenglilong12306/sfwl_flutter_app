import 'dart:async';

import 'package:sfwl_flutter_app/common/utils/code_utils.dart';
import 'package:sfwl_flutter_app/model/AppMenuModel.dart';
import 'package:sfwl_flutter_app/model/UserInfoModel.dart';
import 'package:sqflite/sqflite.dart';

import '../sql_provider.dart';

/**
 * 用户菜单对象表
 * Created by lilong.chen
 * Date: 2022-07-12
 */

class AppMenuDbProvider extends BaseDbProvider {
  final String name = 'AppMenuInfo';

  final String columnId = "_id";

  int? id;
  String? menu_userid;///用户唯一ID,通过ID识别隶属用户
  String? menu_id;///唯一ID
  String? menu_fatherid;///上级菜单
  String? menu_name;///菜单名称
  String? menu_type;///菜单类别,0 = 常用菜单,1 = 定制菜单
  String? menu_version;///版本号,通过此版本号检查是否需要重新读取菜单
  String? menu_ico;///图标
  String? menu_href;///链接地址
  String? menu_order;///菜单排序
  String? menu_action;///打开方式,H5 = URL地址打开,LC = 打开插件
  String? menu_pluginname;///插件名称
  String? menu_pluginversion;///插件版本号
  String? menu_pluginpackage;///插件包名，用于识别插件
  String? menu_buttonkey;///按键key

  AppMenuDbProvider();

  Map<String, dynamic> toMap(String eventMapString) {
    Map<String, dynamic> map = CodeUtils.decodeMapResult(eventMapString);
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  AppMenuDbProvider.fromMap(Map map) {
    id = map[columnId];
    menu_userid = map["menu_userid"];
    menu_id = map["menu_id"];
    menu_fatherid = map["menu_fatherid"];
    menu_name = map["menu_name"];
    menu_type = map["menu_type"];
    menu_version = map["menu_version"];
    menu_ico = map["menu_ico"];
    menu_href = map["menu_href"];
    menu_order = map["menu_order"];
    menu_action = map["menu_action"];
    menu_pluginname = map["menu_pluginname"];
    menu_pluginversion = map["menu_pluginversion"];
    menu_pluginpackage = map["menu_pluginpackage"];
    menu_buttonkey = map["menu_buttonkey"];
  }
  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
        menu_userid text not null
        ,menu_id text not null
        ,menu_fatherid text not null
        ,menu_name text not null
        ,menu_type text not null
        ,menu_version text not null
        ,menu_ico text not null
        ,menu_href text not null
        ,menu_order text not null
        ,menu_action text not null
        ,menu_pluginname text not null
        ,menu_pluginversion text not null
        ,menu_pluginpackage text not null
        ,menu_buttonkey text not null
        )
      ''';
  }

  @override
  tableName() {
    return name;
  }

  /**
   * 通过user_id查询对应的菜单
   */
  Future<List> _getAppMenuProviderByUserId(Database db, String? user_id) async {
    List<AppMenuDbProvider> list = <AppMenuDbProvider>[];
    List<Map<String, dynamic>> maps = await db.query(name,
        columns: [columnId, "menu_userid", "menu_id", "menu_fatherid",
          "menu_name", "menu_type", "menu_version", "menu_ico",
          "menu_href", "menu_order", "menu_action", "menu_pluginname",
          "menu_pluginversion", "menu_pluginpackage", "menu_buttonkey"],
        where: "menu_userid = ?",
        whereArgs: [user_id],
        orderBy:"menu_order asc");
    if (maps.length > 0) {
      for(Map<String, dynamic> map in maps){
        AppMenuDbProvider provider = AppMenuDbProvider.fromMap(map);
        list.add(provider);
      }
      return list;
    }
    return [];
  }

  /**
   * 通过menu_id查询对应的菜单
   */
  Future _getAppMenuProviderByMenuId(Database db, String? menu_id) async {
    List<Map<String, dynamic>> maps = await db.query(name,
        columns: [columnId, "menu_userid", "menu_id", "menu_fatherid",
          "menu_name", "menu_type", "menu_version", "menu_ico",
          "menu_href", "menu_order", "menu_action", "menu_pluginname",
          "menu_pluginversion", "menu_pluginpackage", "menu_buttonkey"],
        where: "menu_id = ?",
        whereArgs: [menu_id]);
    if (maps.length > 0) {
      AppMenuDbProvider provider = AppMenuDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  ///通过menu_id插入到数据库
  Future insert(String menu_id, String eventMapString) async {
    Database db = await getDataBase();
    var userProvider = await _getAppMenuProviderByMenuId(db, menu_id);
    if (userProvider != null) {
      await db
          .delete(name, where: "menu_id = ?", whereArgs: [menu_id]);
    }
    return await db.insert(name, toMap(eventMapString));
  }

  ///通过user_id更新用户菜单对象表
  Future update(String user_id, String eventMapString) async {
    Database db = await getDataBase();
    return await db.update(name, toMap(eventMapString));
  }

  ///通过user_id获取用户菜单对象列表
  Future<List<AppMenuModel>> getAppMenuInfoByUserId(String? user_id) async {
    Database db = await getDataBase();
    List<AppMenuModel> list = <AppMenuModel>[];
    List providerList = await _getAppMenuProviderByUserId(db, user_id);
    if (providerList.length > 0) {
      for(var provider in providerList) {
        AppMenuModel appMenuModel = new AppMenuModel(
            provider.menu_userid,
            provider.menu_id,
            provider.menu_fatherid,
            provider.menu_name,
            int.parse(provider.menu_type),
            provider.menu_version,
            provider.menu_ico,
            provider.menu_href,
            int.parse(provider.menu_order),
            provider.menu_action,
            provider.menu_pluginname,
            provider.menu_pluginversion,
            provider.menu_pluginpackage,
            provider.menu_buttonkey);
        list.add(appMenuModel);
      }
    }
   return list;
  }

  ///通过menu_id获取用户菜单对象
  Future<AppMenuModel?> getAppMenuInfoByMenuId(String? menu_id) async {
    Database db = await getDataBase();
    var provider = await _getAppMenuProviderByMenuId(db, menu_id);
    if (provider != null) {
      AppMenuModel appMenuModel = new AppMenuModel(provider.menu_userid, provider.menu_id,
          provider.menu_fatherid, provider.menu_name, int.fromEnvironment(provider.menu_type), provider.menu_version,
          provider.menu_ico, provider.menu_href, int.fromEnvironment(provider.menu_order), provider.menu_action,
          provider.menu_pluginname, provider.menu_pluginversion, provider.menu_pluginpackage,
          provider.menu_buttonkey);
      return appMenuModel;
    }
    return null;
  }

}
