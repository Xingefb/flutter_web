import 'package:doworking/utils/job_theme.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:url_launcher/url_launcher.dart';

class AlertClose extends Dialog {
  final String text;
  final onTap;
  AlertClose({
    Key key,
    @required this.text,
    this.onTap,
  }) : super(key: key);

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        key: globalKey,
        child: Container(
          padding: EdgeInsets.fromLTRB(26, 54, 26, 0),
          child: Container(
            height: 188,
            // width: 252,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 54),
                    child: Text(
                      '真的要放弃这个职位吗?',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF161515),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                        top: 35,
                        left: 33,
                        right: 33,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: JobColor.red),
                                ),
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  '再想想',
                                  style: TextStyle(
                                      color: JobColor.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                onTap();
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(colors: <Color>[
                                      Color(0xFFFCA2A2),
                                      Color(0xFFFD758D),
                                    ])),
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  '取消报名',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
