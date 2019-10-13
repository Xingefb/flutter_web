import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:doworking/root_pages.dart';
import 'package:doworking/utils/api_go.dart';
import 'package:doworking/utils/channel.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:doworking/utils/no_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_umplus/flutter_umplus.dart';
// import 'package:imei_plugin/imei_plugin.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:meiqiachat/meiqiachat.dart';
import 'package:openinstall_flutter_plugin/openinstall_flutter_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:splashscreen/splashscreen.dart';
// import 'package:um_plugin/um_plugin.dart';

void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String debugLable = 'Unknown';
  final JPush jpush = JPush();
  ApiGo _api = ApiGo.shareInstance();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  OpeninstallFlutterPlugin _openinstallFlutterPlugin;
  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (ConnectivityResult.none == result) {
        debugPrint('have no wifi');
      } else {
        debugPrint('have is wifi first loadData');
        setupJpush();
        setupUmeng();
        setupChat();
        updateId();
        initOpeninstall();
      }
    });
    setupJpush();
    setupUmeng();
    setupChat();
    // updateId();
    initOpeninstall();
  }

  initOpeninstall() async {
    if (!mounted) return;

    _openinstallFlutterPlugin = OpeninstallFlutterPlugin();
    // init
    _openinstallFlutterPlugin.init(wakeupHandler);
    _openinstallFlutterPlugin.install(installHandler);
    setState(() {
      debugLable = "";
    });
  }

  // 拉起
  Future wakeupHandler(Map<String, dynamic> data) async {
    setState(() {
      debugLable = "wakeup result : channel=" +
          data['channelCode'] +
          ", data=" +
          data['bindData'].toString() +
          "\n";
    });
  }

  // 传参
  Future installHandler(Map<String, dynamic> data) async {
    setState(() {
      debugLable = "install result : channel=" +
          data['channelCode'] +
          ", data=" +
          data['bindData'];
    });
  }

  updateId() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // String oldImei = preferences.getString('imei');
      String imei = androidInfo.androidId;
      print('imei => :' + imei + 'androidId => ' + androidInfo.androidId);
      await _api.pushIdfa(data: {
        'os': androidInfo.board,
        'device': androidInfo.device,
        'imei': imei,
        'channel': TChannel.channel,
        'difa': 'android',
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('imei', imei);
    }
    if (Platform.isIOS) {
      String idfa = await jpush.getIdfa();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('idfa', idfa);
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      await _api.pushIdfa(data: {
        'os': iosInfo.systemVersion,
        'device': iosInfo.utsname.machine,
        'idfa': idfa,
        'channel': TChannel.channel
      });
    }
  }

  setupChat() async {
    await Meiqiachat.initMeiqiaSdkWith('31d36651df1e37836a9423d9e5f07130');
  }

  setupUmeng() {
    if (Platform.isIOS) {
      // UmPlugin.setUp('5d78a3ce3fc19514630008e5');
      FlutterUmplus.init('5d78a3ce3fc19514630008e5');
    }
    if (Platform.isAndroid) {
      FlutterUmplus.init('5d8b3c960cafb242b700026c');
      // UmPlugin.setUp('5d8b3c960cafb242b700026c');
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> setupJpush() async {
    String platformVersion;

    jpush.getRegistrationID().then((rid) {
      setState(() {
        debugLable = "flutter getRegistrationID: $rid";
      });
    });

    jpush.setup(
      appKey: Platform.isIOS
          ? '4645ffbbde988deaee0bfe7f'
          : '4645ffbbde988deaee0bfe7f',
      channel: "jpushChannel",
      production: false,
      debug: true,
    );

    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));

    try {
      jpush.addEventHandler(
        onReceiveNotification: (Map<String, dynamic> message) async {
          print("flutter onReceiveNotification: $message");
          setState(() {
            debugLable = "flutter onReceiveNotification: $message";
          });
        },
        onOpenNotification: (Map<String, dynamic> message) async {
          print("flutter onOpenNotification: $message");
          setState(() {
            debugLable = "flutter onOpenNotification: $message";
          });
        },
        onReceiveMessage: (Map<String, dynamic> message) async {
          print("flutter onReceiveMessage: $message");
          setState(() {
            debugLable = "flutter onReceiveMessage: $message";
          });
        },
      );
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      debugLable = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '桃淘兼职',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: JobColor.red,
        accentColor: JobColor.red,
        highlightColor: Colors.transparent,
        splashFactory: NoSplashFactory(),
        appBarTheme: AppBarTheme(
          color: JobColor.white,
          elevation: 0.0,
          textTheme: TextTheme(
              title: TextStyle(
                  color: JobColor.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w500)),
          actionsIconTheme: IconThemeData(),
        ),
      ),
      home: RootPages(),
      // home: SplashScreen(
      //   seconds: 0,
      //   // backgroundColor: Colors.red,
      //   navigateAfterSeconds: RootPages(),
      // ),
    );
  }
}
