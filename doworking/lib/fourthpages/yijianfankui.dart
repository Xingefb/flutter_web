import 'package:doworking/utils/api_go.dart';
import 'package:doworking/utils/base_net.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:doworking/views/view_input_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Yijianfankui extends StatefulWidget {
  Yijianfankui({Key key}) : super(key: key);

  _YijianfankuiState createState() => _YijianfankuiState();
}

class _YijianfankuiState extends State<Yijianfankui> {
  ApiGo _api = ApiGo.shareInstance();
  String _info = '';
  String _contacts = '';

  _push() async {
    ReData res =
        await _api.pushYijian(data: {'contacts': _contacts, 'info': _info});
    if (res.code == '0') {
      Fluttertoast.showToast(msg: '感谢您的反馈', gravity: ToastGravity.CENTER);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: res.text, gravity: ToastGravity.CENTER);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JobColor.white,
      appBar: AppBar(
        title: Text('意见反馈'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 14, top: 25),
            child: Text(
              '反馈内容',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: JobColor.black),
            ),
          ),
          ViewInputView(
            msg: null,
            hintText: '请输入您对我们产品的宝贵意见',
            onConfirm: (String text) {
              _info = text.trim();
              // setState(() {});
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 14, top: 10),
            child: Text(
              '联系方式',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: JobColor.black),
            ),
          ),
          ViewInputView(
            msg: null,
            hintText: '请留下您的邮箱，方便我们与您取得联系',
            onConfirm: (String text) {
              _contacts = text.trim();
              // setState(() {});
            },
          ),
          GestureDetector(
            onTap: () {
              _push();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: Container(
                alignment: Alignment.center,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: JobColor.red,
                ),
                child: Text(
                  '发送',
                  style: TextStyle(
                      fontSize: 18,
                      color: JobColor.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
