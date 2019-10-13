import 'package:doworking/secoundpages/jipin_screen.dart';
import 'package:doworking/secoundpages/zhutui_screen.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:flutter/material.dart';

class SecoundPage extends StatefulWidget {
  SecoundPage({Key key}) : super(key: key);

  _SecoundPageState createState() => _SecoundPageState();
}

class _SecoundPageState extends State<SecoundPage>
    with AutomaticKeepAliveClientMixin {
  bool _currentState = true;
  TextStyle _titleStyle = TextStyle(
      fontSize: 22, fontWeight: FontWeight.w500, color: JobColor.black);
  TextStyle _subTitleStyle = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF8A8A8A));
  PageController _pageController = PageController();

  _switchTitle() {
    _currentState = !_currentState;
    if (_currentState) {
      _pageController.jumpToPage(0);
    } else {
      _pageController.jumpToPage(1);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: JobColor.white,
      appBar: AppBar(
        title: _titleView(),
      ),
      body: PageView(
        onPageChanged: (index) {
          if (index == 0) {
            if (!_currentState) {
              _switchTitle();
            }
          } else {
            if (_currentState) {
              _switchTitle();
            }
          }
        },
        controller: _pageController,
        children: <Widget>[ZhutuiScreen(), JipinScreen()],
      ),
    );
  }

  _titleView() {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (!_currentState) {
              _switchTitle();
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '主推',
              style: _currentState ? _titleStyle : _subTitleStyle,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (_currentState) {
              _switchTitle();
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '急聘',
              style: _currentState ? _subTitleStyle : _titleStyle,
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
