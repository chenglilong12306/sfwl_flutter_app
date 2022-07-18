import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';

/**
 * FileName 用户菜单对象
 * @Author lilong.chen
 * @Date 2022/7/14 15:41
 */

class AppMenuModel{

  late   String menu_userid;///用户唯一ID,通过ID识别隶属用户
  late   String menu_id;///唯一ID
  late   String menu_fatherid;///上级菜单
  late   String menu_name;///菜单名称
  late   int    menu_type;///菜单类别,0 = 常用菜单,1 = 定制菜单
  late   String menu_version;///版本号,通过此版本号检查是否需要重新读取菜单
  late   String menu_ico;///图标
  late   String menu_href;///链接地址
  late   int    menu_order;///菜单排序
  late   String menu_action;///打开方式,H5 = URL地址打开,LC = 打开插件
  late   String menu_pluginname;///插件名称
  late   String menu_pluginversion;///插件版本号
  late   String menu_pluginpackage;///插件包名，用于识别插件
  late   String menu_buttonkey;///按键key


  AppMenuModel(this.menu_userid,this.menu_id,this.menu_fatherid,this.menu_name,
      this.menu_type,this.menu_version,this.menu_ico,this.menu_href,this.menu_order,
      this.menu_action,this.menu_pluginname,this.menu_pluginversion,this.menu_pluginpackage,
      this.menu_buttonkey);


  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map<String, dynamic> toJson() => <String, dynamic>{
    'menu_userid': this.menu_userid,
    'menu_id' :this.menu_id,
    'menu_fatherid' :this.menu_fatherid,
    'menu_name' :this.menu_name,
    'menu_type' :this.menu_type,
    'menu_version' :this.menu_version,
    'menu_ico' :this.menu_ico,
    'menu_href' :this.menu_href,
    'menu_order' :this.menu_order,
    'menu_action' :this.menu_action,
    'menu_pluginname' :this.menu_pluginname,
    'menu_pluginversion' :this.menu_pluginversion,
    'menu_pluginpackage' :this.menu_pluginpackage,
    'menu_buttonkey' :this.menu_buttonkey,
  };

  factory AppMenuModel.fromJson(Map<String, dynamic> jsonStr) {
    return AppMenuModel(jsonStr['menu_userid']
        , jsonStr['menu_id']
        , jsonStr['menu_fatherid']
        , jsonStr['menu_name']
        , int.parse(jsonStr['menu_type'])
        , jsonStr['menu_version'] != null ? jsonStr['menu_version'] : ""
        , jsonStr['menu_ico']
        , jsonStr['menu_href']
        , jsonStr['menu_order']
        , jsonStr['menu_action']
        , jsonStr['menu_pluginname']
        , jsonStr['menu_pluginversion'] != null ? jsonStr['menu_pluginversion'] : ""
        , jsonStr['menu_pluginpackage'] != null ? jsonStr['menu_pluginpackage'] : ""
        , jsonStr['menu_buttonkey']
    );
  }


}