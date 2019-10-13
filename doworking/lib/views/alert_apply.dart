import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class AlertApply extends Dialog {
  final String text;
  final onTap;
  final copyMsg;

  AlertApply({
    Key key,
    @required this.text,
    this.onTap,
    this.copyMsg,
  }) : super(key: key);

  final GlobalKey globalKey = GlobalKey();

  _copyMsg() async {
    Clipboard.setData(ClipboardData(text: text.split(' ').last ?? ''));
    copyMsg();
    String msg = text.split(' ').last ?? '';
    String type = text.split(' ').first;
    if (type == '电话' || type == '手机') {
      if (await canLaunch('tel:$msg')) {
        launch('tel:$msg');
      } else {
        Fluttertoast.showToast(msg: '模拟器不支持拨打电话', gravity: ToastGravity.CENTER);
      }
    } else if (type == 'QQ') {
      if (Platform.isIOS && await canLaunch('mqq://')) {
        await launch(
            'mqq://im/chat?chat_type=wpa&version=1&src_type=web&uin=$msg');
      } else if (Platform.isAndroid) {
        await launch('mqqwpa://im/chat?chat_type=wpa&uin=$msg');
      } else {
        Fluttertoast.showToast(
          msg: '请安装QQ',
          gravity: ToastGravity.CENTER,
        );
      }
    } else if (type == '微信') {
      if (Platform.isIOS && await canLaunch('weixin://')) {
        await launch('weixin://');
      } else if (Platform.isAndroid) {
        await launch('weixin://');
      } else {
        Fluttertoast.showToast(
          msg: '请安装微信',
          gravity: ToastGravity.CENTER,
        );
      }
    } else {
      Fluttertoast.showToast(msg: '已复制到剪切板', gravity: ToastGravity.CENTER);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        key: globalKey,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(66, 47, 66, 0),
              child: Container(
                height: 230,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 37),
                        child: Text(
                          '报名成功',
                          style: TextStyle(
                              fontSize: 19,
                              color: Color(0xFF161515),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 11),
                          child: Text(
                            '请主动联系商家完成\n录取内容，才能成功入职',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xFF8A8A8A), fontSize: 14),
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          text,
                          style: TextStyle(
                              color: Color(0xFFFD758D),
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 13,
                          left: 40,
                          right: 40,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            _copyMsg();
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(colors: <Color>[
                                  Color(0xFFFCA2A2),
                                  Color(0xFFFD758D),
                                ])),
                            height: 40,
                            alignment: Alignment.center,
                            child: Text(
                              (text.split(' ').first == '手机' ||
                                      text.split(' ').first == '电话')
                                  ? '打电话给商家'
                                  : (text.split(' ').first == 'QQ' ||
                                          text.split(' ').first == '微信')
                                      ? '复制并跳转${text.split(' ').first}'
                                      : '复制信息',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 40,
              top: 30,
              child: Image.asset(
                'assets/images/applyicon@2x.png',
                width: 90,
                height: 90,
              ),
            ),
            Positioned(
              right: 60,
              bottom: 0,
              child: Image.asset(
                'assets/images/applyicon2@2x.png',
                width: 40,
                height: 40,
              ),
            ),
            Positioned(
                right: 66 + 8.0,
                top: 47 + 8.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/images/cancle_icon@2x.png',
                    width: 25,
                    height: 25,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
