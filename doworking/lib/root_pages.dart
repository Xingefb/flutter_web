import 'package:doworking/rootpages/first_page.dart';
import 'package:doworking/rootpages/fourth_page.dart';
import 'package:doworking/rootpages/secound_page.dart';
import 'package:doworking/rootpages/third_page.dart';
import 'package:flutter/material.dart';

class RootPages extends StatefulWidget {
  RootPages({Key key}) : super(key: key);

  _RootPagesState createState() => _RootPagesState();
}

class _RootPagesState extends State<RootPages> {
  int _currentIndex = 0;
  PageController _controller = PageController();
  Image _configItem(name) {
    return Image.asset(
      name,
      width: 24,
      fit: BoxFit.fitWidth,
    );
  }

  List<BottomNavigationBarItem> _items() {
    return [
      BottomNavigationBarItem(
          icon: _configItem('assets/images/首页@2x.png'),
          activeIcon: _configItem('assets/images/首页s@2x.png'),
          title: Text('首页')),
      BottomNavigationBarItem(
          icon: _configItem('assets/images/优选@2x.png'),
          activeIcon: _configItem('assets/images/优选s@2x.png'),
          title: Text('优选')),
      BottomNavigationBarItem(
          icon: _configItem('assets/images/消息@2x.png'),
          activeIcon: _configItem('assets/images/消息s@2x.png'),
          title: Text('消息')),
      BottomNavigationBarItem(
          icon: _configItem('assets/images/我的@2x.png'),
          activeIcon: _configItem('assets/images/我的s@2x.png'),
          title: Text('我的')),
    ];
  }

  List<Widget> _pages() {
    return [FirstPage(), SecoundPage(), ThirdPage(), FourthPage()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _controller,
        children: _pages(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        items: _items(),
        currentIndex: _currentIndex,
        onTap: (index) {
          _currentIndex = index;
          _controller.jumpToPage(index);
          setState(() {});
        },
      ),
    );
  }
}
