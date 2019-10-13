import 'package:flutter/material.dart';

enum NoDataType { NoWiFI, NoData, NoCollection, NoNews }

class ViewNoData extends StatefulWidget {
  ViewNoData({Key key, @required this.type, this.onTap}) : super(key: key);
  final NoDataType type;
  final onTap;
  _ViewNoDataState createState() => _ViewNoDataState();
}

class _ViewNoDataState extends State<ViewNoData> {
  List _titles = ['网络连接异常\n点击屏幕重新加载', '暂时没有数据显示', '暂时没有可收藏的内容', '暂时还没有通知任何消息呢'];
  List _icons = [
    'assets/images/nowifi@2x.png',
    'assets/images/nodata@2x.png',
    'assets/images/nocollect@2x.png',
    'assets/images/nonews@2x.png'
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(_icons[widget.type.index],
                width: 173, fit: BoxFit.fitWidth),
            Padding(
              padding: EdgeInsets.only(top: 14),
              child: Text(
                _titles[widget.type.index],
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF8A8A8A)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
