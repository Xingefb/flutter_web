import 'package:doworking/utils/all_eventbus.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:doworking/utils/tao_cache.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key key}) : super(key: key);

  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  TaoCache _cacheGo = TaoCache.shareInstance();

  String _cacheNum = '0.00B';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _cleanCache() async {
    _cacheNum = await _cacheGo.clearCache();
    setState(() {});
  }

  _loadData() async {
    _cacheNum = await _cacheGo.loadCache();
    setState(() {});
  }

  _exit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await preferences.remove('token')) {
      eventBus.fire(RefreshUserInfoEventBus(true));
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              color: Colors.white,
              height: 50,
              child: GestureDetector(
                onTap: () => _cleanCache(),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '清除缓存',
                      style: TextStyle(fontSize: 14, color: JobColor.black),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Text(
                      _cacheNum,
                      style: TextStyle(fontSize: 14, color: Color(0xFFA0A0A0)),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: 12, color: Color(0xFFA0A0A0))
                  ],
                ),
              ),
            ),
            Container(
              height: 10,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _exit,
              child: Container(
                color: Colors.white,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  '退出登录',
                  style: TextStyle(color: Color(0xFFF03C3C), fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
