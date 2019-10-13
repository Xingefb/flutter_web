import 'package:doworking/utils/job_theme.dart';
import 'package:flutter/material.dart';

class ViewTitle extends StatefulWidget {
  ViewTitle({Key key, @required this.title}) : super(key: key);
  final String title;
  _ViewTitleState createState() => _ViewTitleState();
}

class _ViewTitleState extends State<ViewTitle> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 5),
          child: Image.asset(
            'assets/images/head_image@2x.png',
            width: 10,
            fit: BoxFit.fitWidth,
          ),
        ),
        Expanded(
          child: Text(
            widget.title,
            style: JobStyle.headStyle,
          ),
        ),
      ],
    );
  }
}
