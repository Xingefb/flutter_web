import 'package:doworking/utils/job_theme.dart';
import 'package:doworking/views/view_nodata.dart';
import 'package:flutter/material.dart';

class SystemScreen extends StatefulWidget {
  SystemScreen({Key key}) : super(key: key);

  _SystemScreenState createState() => _SystemScreenState();
}

class _SystemScreenState extends State<SystemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JobColor.white,
      appBar: AppBar(
        title: Text('系统通知'),
      ),
      body: ViewNoData(
        type: NoDataType.NoNews,
      ),
    );
  }
}
