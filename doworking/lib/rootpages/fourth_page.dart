import 'package:cached_network_image/cached_network_image.dart';
import 'package:doworking/fourthpages/abouttaotao.dart';
import 'package:doworking/fourthpages/collections.dart';
import 'package:doworking/fourthpages/lianxiwomen.dart';
import 'package:doworking/fourthpages/login.dart';
import 'package:doworking/fourthpages/person_center.dart';
import 'package:doworking/fourthpages/setting_screen.dart';
import 'package:doworking/fourthpages/types_screen.dart';
import 'package:doworking/fourthpages/wodejianli.dart';
import 'package:doworking/fourthpages/yijianfankui.dart';
import 'package:doworking/models/model_user.dart';
import 'package:doworking/utils/all_eventbus.dart';
import 'package:doworking/utils/api_go.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FourthPage extends StatefulWidget {
  FourthPage({Key key}) : super(key: key);

  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage>
    with AutomaticKeepAliveClientMixin {
  // Navigator.push(context, MaterialPageRoute(builder: (context) => PageWodejianli()));

  List _types = [
    {'title': '全部', 'icon': 'assets/images/全部@2x.png'},
    {'title': '已报名', 'icon': 'assets/images/已报名@2x.png'},
    {'title': '已录取', 'icon': 'assets/images/已录取@2x.png'},
    {'title': '已完成', 'icon': 'assets/images/已完成@2x.png'},
  ];
  List _items = [
    {'title': '我的简历', 'icon': 'assets/images/我的简历@2x.png'},
    {'title': '我的投递', 'icon': 'assets/images/我的投递@2x.png'},
    {'title': '职位收藏', 'icon': 'assets/images/职位收藏@2x.png'},
    {'title': '联系我们', 'icon': 'assets/images/联系我们@2x.png'},
    {'title': '关于我们', 'icon': 'assets/images/关于我们@2x.png'},
    {'title': '意见反馈', 'icon': 'assets/images/意见反馈@2x.png'},
  ];
  ApiGo _api = ApiGo.shareInstance();
  ModelUser _model;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    eventBus.on<RefreshUserInfoEventBus>().listen((data) {
      if (data.isRefresh) {
        _getUserInfo();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getUserInfo() async {
    try {
      var res = await _api.getUserInfo();
      _model = ModelUser.fromJson(res);
      setState(() {});
    } catch (e) {}
  }

  _toEditUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('token');
    if (null == token) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
      return;
    }
    if (null == _model) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonCenter(
          model: _model,
        ),
      ),
    );
  }

  _toTypesWithIndex(index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('token');
    if (null == token) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
      return;
    }
    if (null == _model) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TypesScreen(
          currentIndex: index,
        ),
      ),
    );
  }

  _toPageWithIndex(index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('token');
    if (null == token && [0, 1, 2].contains(index)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }
    switch (index) {
      case 0:
        if (null == _model) {
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PageWodejianli(
              model: _model,
            ),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TypesScreen(
              currentIndex: 0,
            ),
          ),
        );
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Collections()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PageLianxiwomen()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AboutTaotao()));
        break;
      case 5:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Yijianfankui()));
        break;
      default:
    }
  }

  _toSetting() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('token');
    if (null == token) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingScreen()))
        .then((onValue) {
      if (onValue) {
        _model = null;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Color(0xFFF6F6F6),
        actions: <Widget>[
          IconButton(
            icon: Image.asset(
              'assets/images/setting@2x.png',
              width: 19,
              fit: BoxFit.fitWidth,
            ),
            onPressed: _toSetting,
          )
        ],
      ),
      body: SafeArea(
          child: CustomScrollView(
        slivers: <Widget>[
          _userView(width),
          _typesView(width),
          _itemsView(),
        ],
      )),
    );
  }

  _itemsView() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          padding: EdgeInsets.only(top: 11, bottom: 34),
          decoration: BoxDecoration(
            color: JobColor.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: List.generate(_items.length, (index) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _toPageWithIndex(index);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        _items[index]['icon'],
                        width: 16,
                        height: 16,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 13),
                        child: Text(
                          _items[index]['title'],
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: JobColor.black),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Color(0xFF8A8A8A),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  _typesView(width) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 11),
        child: Container(
          decoration: BoxDecoration(
            color: JobColor.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_types.length, (index) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _toTypesWithIndex(index);
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 15),
                  child: Column(
                    children: <Widget>[
                      ClipOval(
                        child: Image.asset(
                          _types[index]['icon'],
                          width: 34,
                          height: 34,
                          // color: JobColor.red,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 7),
                        child: Text(
                          _types[index]['title'],
                          style: TextStyle(fontSize: 14, color: JobColor.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  _userView(width) {
    return SliverToBoxAdapter(
        child: GestureDetector(
      onTap: () {
        _toEditUserInfo();
      },
      child: Container(
        padding: EdgeInsets.only(top: 15),
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Container(
              width: width,
              height: 160,
            ),
            Column(
              children: <Widget>[
                Container(
                  height: 30,
                ),
                Container(
                  width: width,
                  height: 130,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                        color: JobColor.white,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: _model?.img ?? '',
                    width: 74,
                    height: 74,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Image.asset(
                        'assets/images/默认头像@2x.png',
                        fit: BoxFit.cover,
                        width: 74,
                        height: 74,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 11),
                  child: Text(
                    null == _model
                        ? '点击登录'
                        : ((null == _model?.nickname || _model.nickname.isEmpty)
                            ? '编辑信息'
                            : _model?.nickname),
                    style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFF161515),
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    null == _model
                        ? '快来登录获取自己的权益吧'
                        : ((null == _model?.sign || _model.sign.isEmpty)
                            ? '编写个性签名'
                            : _model?.sign),
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
