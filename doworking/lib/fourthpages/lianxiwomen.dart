import 'package:doworking/utils/api_go.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:flutter/material.dart';

class PageLianxiwomen extends StatefulWidget {
  PageLianxiwomen({Key key}) : super(key: key);

  _PageLianxiwomenState createState() => _PageLianxiwomenState();
}

class _PageLianxiwomenState extends State<PageLianxiwomen> {
  ApiGo _api = ApiGo.shareInstance();
  String str = '';
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    str = await _api.lianxiwomen();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JobColor.white,
      appBar: AppBar(
        title: Text('联系我们'),
      ),
      body: Center(
        child: Container(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Container(
                width: 212,
                height: 212,
                child: Image.asset('assets/images/联系我们.png'),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'QQ号 ' + str ?? '2453993162',
                  style: TextStyle(color: Color(0xFFFD758D), fontSize: 21),
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
