import 'package:doworking/models/model_user.dart';
import 'package:doworking/utils/all_eventbus.dart';
import 'package:doworking/utils/api_go.dart';
import 'package:doworking/utils/base_net.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:doworking/views/view_input_view.dart';
import 'package:doworking/views/view_msg_input.dart';
import 'package:doworking/views/view_msg_select.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PersonCenter extends StatefulWidget {
  PersonCenter({Key key, @required this.model}) : super(key: key);
  final ModelUser model;
  _PersonCenterState createState() => _PersonCenterState();
}

class _PersonCenterState extends State<PersonCenter> {
  ApiGo _api = ApiGo.shareInstance();

  int _age;
  int _sex;
  String _nickname;
  String _sign;

  @override
  void initState() {
    super.initState();
    _age = widget.model?.age ?? 0;
    _nickname = widget.model?.nickname ?? '';
    _sex = widget.model?.sex ?? 0;
    _sign = widget.model?.sign ?? '';
  }

  _save() async {
    ReData res = await _api.pushUserInfo(data: {
      'age': _age,
      'sex': _sex,
      'nickname': _nickname,
      'sign': _sign,
    });
    if (res.code == '0') {
      eventBus.fire(RefreshUserInfoEventBus(true));
      Fluttertoast.showToast(msg: '保存成功', gravity: ToastGravity.CENTER);
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
        title: Text('修改信息'),
        elevation: 0.6,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              _save();
            },
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '保存',
                style: TextStyle(fontSize: 15),
              ),
              padding: EdgeInsets.only(right: 15),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          _topBody(),
          _diyMsg(),
          _diyBody(),
        ],
      ),
    );
  }

  _diyBody() {
    return SliverToBoxAdapter(
      child: Container(
        child: ViewInputView(
          msg: _sign,
          hintText: '请输入个性签名，不超过15个字',
          limitLength: 15,
          onConfirm: (String text) {
            _sign = text.trim();
            // setState(() {});
            print('个性签名 =》 '+_sign);
          },
        ),
      ),
    );
  }

  _diyMsg() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(left: 15, top: 23),
        child: Text(
          '个性签名',
          style: TextStyle(fontSize: 14, color: Color(0xFF39393A)),
        ),
      ),
    );
  }

  _topBody() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            ViewMsgInput(
              title: '姓名',
              limitLength: 5,
              msg: _nickname,
              hintText: '请输入真实姓名',
              onConfirm: (String text) {
                _nickname = text.trim();
                // setState(() {});
              },
            ),
            ViewMsgSelect(
              data: List.generate(43, (index) {
                return (18 + index).toString();
              }),
              msg: _age.toString(),
              title: '年龄',
              hintText: '请选择您的年龄',
              onConfirm: (text) {
                _age = int.parse(text);
                setState(() {});
              },
            ),
            ViewMsgSelect(
              data: [
                '男',
                '女',
              ],
              msg: (_sex == 1 ? '女' : '男'),
              title: '性别',
              hintText: '请选择您的性别',
              onConfirm: (text) {
                _sex = (text == '女' ? 1 : 2);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
