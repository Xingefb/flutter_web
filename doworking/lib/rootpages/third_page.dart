import 'dart:io';

import 'package:doworking/thirdpages/system_screen.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:flutter/material.dart';
import 'package:meiqiachat/meiqiachat.dart';

class ThirdPage extends StatefulWidget {
  ThirdPage({Key key}) : super(key: key);

  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage>
    with AutomaticKeepAliveClientMixin {
  List _iconTitle = [
    {
      'title': '系统通知',
      'icon': 'assets/images/通知@2x.png',
      'msg': '关于APP的任何通知都可以在这里查看哦'
    },
    {
      'title': '联系客服',
      'icon': 'assets/images/客服@2x.png',
      'msg': '有什么问题请及时联系客服反馈'
    },
  ];

  _toPage(index) async {
    if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SystemScreen()));
    } else {
      Meiqiachat.toChat();
      print('to chat');
    }
  }

  _iconView(index) {
    return GestureDetector(
      onTap: () {
        _toPage(index);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          children: <Widget>[
            Image.asset(
              _iconTitle[index]['icon'],
              width: 54,
              height: 54,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 10, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _iconTitle[index]['title'],
                    style: TextStyle(fontSize: 16, color: JobColor.black),
                  ),
                  Text(
                    _iconTitle[index]['msg'],
                    style: TextStyle(fontSize: 12, color: Color(0xFFAFACAC)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: JobColor.white,
      appBar: AppBar(
        title: Platform.isAndroid
            ? Text(
                '消息',
                style: TextStyle(
                    // color: JobColor.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w500),
              )
            : Text('消息'),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          _iconView(0),
          _iconView(1),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
