import 'package:doworking/utils/job_theme.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AboutTaotao extends StatefulWidget {
  AboutTaotao({Key key}) : super(key: key);

  _AboutTaotaoState createState() => _AboutTaotaoState();
}

class _AboutTaotaoState extends State<AboutTaotao> {
  String version = '';

  @override
  void initState() {
    super.initState();
    _version();
  }

  _version() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JobColor.white,
      appBar: AppBar(
        title: Text('关于我们'),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SizedBox(),
              flex: 1,
            ),
            Image.asset(
              'assets/images/taotao@2x.png',
              width: 87,
              height: 87,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                '桃淘兼职v' + version,
                style: TextStyle(
                    fontSize: 14,
                    color: JobColor.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                '想要靠谱真实的好工作，那快来桃淘兼职',
                style: TextStyle(fontSize: 12, color: JobColor.black),
              ),
            ),
            Expanded(
              child: SizedBox(),
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
