import 'dart:async';
import 'package:doworking/utils/api_go.dart';
import 'package:doworking/utils/base_net.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'dart:convert' as convert;

/// 墨水瓶（`InkWell`）可用时使用的字体样式。
final TextStyle _availableStyle = TextStyle(
    fontSize: 15.0, color: Color(0xFFFD758D), fontWeight: FontWeight.w500);

/// 墨水瓶（`InkWell`）不可用时使用的样式。
final TextStyle _unavailableStyle = TextStyle(
    fontSize: 15.0, color: Color(0xFFC6B6B9), fontWeight: FontWeight.w500);

class ViewCountDownBtn extends StatefulWidget {
  /// 倒计时的秒数，默认60秒。
  final int countdown;

  /// 用户点击时的回调函数。
  final onTapCallback;

  /// 是否可以获取验证码，默认为`false`。
  final bool available;
  final String phone;

  ViewCountDownBtn({
    this.countdown: 59,
    @required this.onTapCallback,
    this.available: false,
    this.phone,
  });

  @override
  _ViewCountDownBtnState createState() => _ViewCountDownBtnState();
}

class _ViewCountDownBtnState extends State<ViewCountDownBtn> {
  Timer _timer;
  int _seconds;

  TextStyle inkWellStyle = _availableStyle;
  String _verifyStr = '获取验证码';
  ApiGo _netGo = ApiGo.shareInstance();

  @override
  void initState() {
    super.initState();
    _seconds = widget.countdown;
  }

  @override
  void dispose() {
    // if (null != _timer) {}
    _timer?.cancel();
    super.dispose();
  }

  /// 启动倒计时的计时器。
  void _startTimer() {
    // 计时器（`Timer`）组件的定期（`periodic`）构造函数，创建一个新的重复计时器。
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        _seconds = widget.countdown;
        inkWellStyle = _availableStyle;
        setState(() {});
        return;
      }
      _seconds--;
      _verifyStr = '已发送$_seconds' + 's';
      setState(() {});
      if (_seconds == 0) {
        _verifyStr = '重新发送';
      }
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  /// 获取验证码
  void _getCode() async {
    ReData res = await _netGo.getCode(data: {'tel': widget.phone});
    if (res.code == '0') {
      _startTimer();
      inkWellStyle = _unavailableStyle;
      _verifyStr = '已发送$_seconds' + 's';
      setState(() {});
      print('run type '+res.info.runtimeType.toString());
      // Map<String, dynamic> info = convert.jsonDecode(res.info);
      // print('code is'+info.toString());
      widget.onTapCallback(res.info['codeid']);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 墨水瓶（`InkWell`）组件，响应触摸的矩形区域。
    return widget.available
        ? InkWell(
            child: Text(
              '  $_verifyStr  ',
              style: inkWellStyle,
            ),
            onTap: (_seconds == widget.countdown)
                ? () {
                    // debugPrint(widget.phone);
                    if (null == widget.phone || widget.phone.isEmpty) {
                      Fluttertoast.showToast(
                          msg: '请输入手机号', gravity: ToastGravity.CENTER);
                    } else {
                      RegExp exp = RegExp(r'^(1[0-9])\d{9}$');
                      bool matched = exp.hasMatch(widget.phone);
                      matched
                          ? _getCode()
                          : Fluttertoast.showToast(
                              msg: '请输入正确的手机号', gravity: ToastGravity.CENTER);
                    }
                  }
                : null,
          )
        : InkWell(
            child: Text(
              '  获取验证码  ',
              style: _unavailableStyle,
            ),
          );
  }
}
