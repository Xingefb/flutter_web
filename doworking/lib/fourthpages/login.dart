import 'package:doworking/fourthpages/xieyi.dart';
import 'package:doworking/utils/all_eventbus.dart';
import 'package:doworking/utils/api_go.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:doworking/views/view_countdown_btn.dart';
import 'package:doworking/views/view_text_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _phone;
  String _code;
  String _codeid='';
  ApiGo _api = ApiGo.shareInstance();

  _login() async {
    print(_phone + _code + _codeid);
    RegExp exp = RegExp(r'^(1[0-9])\d{9}$');
    bool matched = exp.hasMatch(_phone);
    if (!matched) {
      Fluttertoast.showToast(msg: '请输入正确手机号', gravity: ToastGravity.CENTER);
      return;
    }
    if (_code.isEmpty || null == _code) {
      Fluttertoast.showToast(msg: '请输入验证码', gravity: ToastGravity.CENTER);
      return;
    }

    try {
      String token =
          await _api.login(data: {'tel': _phone, 'code': _code, 'id': _codeid});
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('token', token);
      eventBus.fire(RefreshUserInfoEventBus(true));
      Navigator.pop(context);
      print('token => ' + token);
    } catch (e) {}
  }

  _xieyi() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => XieYi()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          _topView(),
          _bodyView(),
          _bottomView(),
        ],
      ),
    );
  }

  _bottomView() {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '点击登录注册即表示您已同意',
              style: TextStyle(color: Color(0xFF8A8A8A), fontSize: 14),
            ),
            GestureDetector(
              onTap: () {
                _xieyi();
              },
              child: Text(
                '用户服务协议',
                style: TextStyle(color: Color(0xFFFD758D), fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _bodyView() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(colors: <Color>[
              Color(0xFFFCA2A2),
              Color(0xFFFB8499),
            ], begin: Alignment.topLeft, end: Alignment.bottomCenter),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 80, 15, 20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 50,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: ViewTextField(
                    hintText: '请输入手机号码',
                    limitLength: 11,
                    onChanged: (String text) {
                      _phone = text.trim();
                      setState(() {});
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 53),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 50,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ViewTextField(
                          hintText: '请输入验证码',
                          limitLength: 6,
                          onChanged: (String text) {
                            _code = text.trim();
                            setState(() {});
                          },
                        ),
                      ),
                      Container(
                        child: ViewCountDownBtn(
                          phone: _phone,
                          available: true,
                          onTapCallback: (text) {
                            _codeid = text;
                            setState(() {});
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 56),
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: GestureDetector(
                    onTap: () {},
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            splashColor: Colors.white,
                            highlightColor: Colors.white,
                            textColor: JobColor.red,
                            child: Text(
                              '登录',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onPressed: _login,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _topView() {
    return SliverToBoxAdapter(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 50, top: 52),
              child: Text(
                'Hi 欢迎来到桃淘兼职',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF161515)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 50, top: 5),
              child: Text(
                '登录桃淘兼职，寻找属于你自己的心仪工作',
                style: TextStyle(fontSize: 13, color: Color(0xFFB0B0B0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
