import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sfwl_flutter_app/Constants.dart';
import 'package:sfwl_flutter_app/common/db/provider/AppMenuDbProvider.dart';
import 'package:sfwl_flutter_app/common/db/provider/UserInfoDbProvider.dart';
import 'package:sfwl_flutter_app/common/utils/JsonUtil.dart';
import 'package:sfwl_flutter_app/model/AppMenuModel.dart';
import 'package:sfwl_flutter_app/model/UserInfoModel.dart';
import 'package:sfwl_flutter_app/model/request/GetMenuModel.dart';
import 'package:sfwl_flutter_app/ui/home_page.dart';
import 'package:sfwl_flutter_app/utils/navigator_utils.dart';
import 'Global.dart';
import 'common/net/Api.dart';
import 'common/net/Dio_utils.dart';
import 'common/utils/DataHelper.dart';
import 'common/utils/JSONObject.dart';
import 'model/request/LoginModel.dart';

void main() => Global.init().then((e) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginRoute (),
    );
  }
}
class LoginRoute  extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  TextEditingController _unameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  bool pwdShow = false;
  GlobalKey _formKey = GlobalKey<FormState>();
  bool _nameAutoFocus = true;

  @override
  void initState() {
    // 自动填充上次登录的用户名，填充后将焦点定位到密码输入框
    // _unameController.text = Global.profile.lastLogin ?? "";
    if(Global.spUtil.get(Constants.USERID).toString() != null){
      _unameController.text = Global.spUtil.get(Constants.USERUID).toString();
      // _pwdController.text = Global.spUtil.get(Constants.USERPWD).toString();
    }
    if (_unameController.text.isNotEmpty) {
      _nameAutoFocus = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var gm = GmLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("登录")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              TextFormField(
                  autofocus: _nameAutoFocus,
                  controller: _unameController,
                  decoration: InputDecoration(
                    labelText: "用户名",
                    hintText: "请输入用户名",
                    prefixIcon: Icon(Icons.person),
                  ),
                  // 校验用户名（不能为空）
                  validator: (v) {
                    return v==null||v.trim().isNotEmpty ? null : "用户名不允许为空";
                  }),
              TextFormField(
                controller: _pwdController,
                autofocus: !_nameAutoFocus,
                decoration: InputDecoration(
                    labelText: "密码",
                    hintText: "请输入密码",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          pwdShow ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          pwdShow = !pwdShow;
                        });
                      },
                    )),
                obscureText: !pwdShow,
                //校验密码（不能为空）
                validator: (v) {
                  return v==null||v.trim().isNotEmpty ? null : "密码不允许为空";
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 55.0),
                  child: ElevatedButton(
                    // color: Theme.of(context).primaryColor,
                    onPressed: _onLogin,
                    // textColor: Colors.white,
                    child: Text("登录"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /**
   * 登录
   */
  void _onLogin() async {
    ///登录请求
    LoginModel loginModel;
    loginModel = new LoginModel(_unameController.text,DataHelper.string2MD5_16(_pwdController.text));
    final res = await HttpUtils.instance.post(
      Api.loginUrl,
      params:JsonUtil.setPostRequestParams(json.encode(loginModel.toJson()), "").toJson(),
      tips: true,
    );
    // print(res.data);
    ///将服务器返回的内容转成model
    UserInfoModel userInfoModel = UserInfoModel.fromJson(res.data);
    ///将用户信息存储在SharedPreferences 中
    Global.spUtil.setString(Constants.USERID, userInfoModel.user_id);
    Global.spUtil.setString(Constants.USERPWD, userInfoModel.user_app_pwd);
    Global.spUtil.setString(Constants.USERUID, userInfoModel.user_uid);
    ///将用户信息存储到数据库中
    UserInfoDbProvider userInfoDbProvider = new UserInfoDbProvider();
    UserInfoModel? user = await userInfoDbProvider.getUserInfo(userInfoModel.user_id);

    ///将数据库中的用户信息取出转换成model
    // print(user?.toJson().toString());
    if(user != null){
      ///更新用户数据
      userInfoDbProvider.update(userInfoModel.user_id, jsonEncode(userInfoModel.toJson()));
    }else{
      ///新增用户数据
      userInfoDbProvider.insert(userInfoModel.user_id, jsonEncode(userInfoModel.toJson()));
    }
    ///获取用户菜单请求
    GetMenuModel getMenuModel = new GetMenuModel(userInfoModel.user_id);
    final getMenusUrlRes = await HttpUtils.instance.post(
      Api.getMenusUrl,
      params: JsonUtil.setPostRequestParams(json.encode(getMenuModel.toJson()), "").toJson(),
      tips: true,
    );
    ///将服务器返回的内容转成model
    ///将用户菜单信息存储到数据库中
    AppMenuDbProvider appMenuDbProvider = new AppMenuDbProvider();
    for(var item in getMenusUrlRes.data) {
      AppMenuModel appMenuModel = AppMenuModel.fromJson(item);
      ///新增用户菜单数据
      appMenuDbProvider.insert(
          appMenuModel.menu_id, jsonEncode(appMenuModel.toJson()));
    }
    List<AppMenuModel> appMenuModelList = await appMenuDbProvider
        .getAppMenuInfoByUserId(Global.spUtil.getString(Constants.USERID));
    print("已存入" +appMenuModelList.length.toString());
    NavigatorUtils.gotoHomePage(context);


  }
}
