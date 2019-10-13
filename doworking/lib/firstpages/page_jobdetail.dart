import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:doworking/fourthpages/login.dart';
import 'package:doworking/models/model_job_cell.dart';
import 'package:doworking/utils/all_eventbus.dart';
import 'package:doworking/utils/api_go.dart';
import 'package:doworking/utils/base_net.dart';
import 'package:doworking/utils/channel.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:doworking/views/alert_apply.dart';
import 'package:doworking/views/alert_lianxi.dart';
import 'package:doworking/views/view_nodata.dart';
import 'package:doworking/views/view_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_umplus/flutter_umplus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:openinstall_flutter_plugin/openinstall_flutter_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageJobDetail extends StatefulWidget {
  PageJobDetail(
      {Key key,
      @required this.model,
      @required this.posi,
      @required this.order})
      : super(key: key);
  final ModelJobCell model;
  final posi;
  final order;
  _PageJobDetailState createState() => _PageJobDetailState();
}

class _PageJobDetailState extends State<PageJobDetail> {
  ApiGo _api = ApiGo.shareInstance();
  OpeninstallFlutterPlugin _openinstallFlutterPlugin =
      OpeninstallFlutterPlugin();
  bool _isCollect = false;
  bool _isJoin = false;
  ModelJobCell _model;
  bool _hWifi = true;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if (ConnectivityResult.none == result) {
        debugPrint('have no wifi');
        _hWifi = false;
      } else {
        _hWifi = true;
        debugPrint('have is wifi first loadData');
        _loadData();
      }
      setState(() {});
    });
    eventBus.on<RefreshUserInfoEventBus>().listen((onData) {
      if (onData.isRefresh) {
        _loadData();
      }
    });
    _loadData();
    _upLook();
  }

  _upLook() async {
    _openinstallFlutterPlugin.reportEffectPoint("LookJobDetail", 1);
    // await FlutterUmplus.event('LookJobDetail');
    await FlutterUmplus.event('LookJobDetail',
        label: widget.model.id.toString());
  }

  _loadData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String imei = pref.getString('imei');
    String idfa = pref.getString('idfa');
    var res = await _api.jobDetail(data: {
      'pid': widget.model?.pid ?? widget.model?.id,
      'posi': widget.posi,
      'imei': imei,
      'idfa': idfa,
      'order': widget.order + 1,
      'channel': TChannel.channel
    });
    _model = ModelJobCell.fromJson(res);
    _isCollect = (_model?.collect == 1) ? true : false;
    _isJoin = _model?.join == 1 ? true : false;
    setState(() {});
  }

  _collectJob() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (null == pref.getString('token')) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }

    ReData res = await _api.toCollect(
        data: {'pid': widget.model.pid, 'status': _isCollect ? 0 : 1});
    if (res.code == '0') {
      _isCollect = !_isCollect;
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: res.text, gravity: ToastGravity.CENTER);
    }
  }

  _toApply() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (null == pref.getString('token')) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }
    if (!_isJoin) {
      ReData res = await _api.toJoinJob(
          data: {'pid': widget.model.id, 'status': 1, 'channel': TChannel.channel});
      if (res.code == '0') {
        _isJoin = true;
        setState(() {});
        _toShow();
      } else {
        Fluttertoast.showToast(msg: res.text, gravity: ToastGravity.CENTER);
      }
    }
    _openinstallFlutterPlugin.reportEffectPoint("SignJobPoint", 1);
    // await UmPlugin.addEvent('SignJobPoint', label: widget.model.id.toString());
    await FlutterUmplus.event('SignJobPoint',
        label: widget.model.id.toString());
  }

  _copyMsg() async {
    Clipboard.setData(
        ClipboardData(text: _model.contace.split(',').last ?? ''));
    Fluttertoast.showToast(msg: '已复制到剪切板', gravity: ToastGravity.CENTER);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String imei = pref.getString('imei');
    String idfa = pref.getString('idfa');
    _api.updateCopy(data: {
      'pid': _model.id,
      'idfa': idfa,
      'imei': imei,
      'channel': TChannel.channel
    });
    _openinstallFlutterPlugin.reportEffectPoint("CopyJobPoint", 1);
    FlutterUmplus.event('CopyJobPoint', label: _model?.id.toString());
  }

  _toShow() async {
    showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertApply(
            text: _model.contace.replaceAll(',', ' '),
            copyMsg: () {
              _copyMsg();
            },
          );
        });
  }

  _lianxi() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertLianxi(
          text: _model.contace.replaceAll(',', ' '),
          copyMsg: () {
            _copyMsg();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JobColor.white,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Image.asset(
              _isCollect
                  ? 'assets/images/collect_s@2x.png'
                  : 'assets/images/collect_n@2x.png',
              width: 24,
            ),
            onPressed: _collectJob,
          ),
        ],
      ),
      body: _hWifi
          ? (null == _model ? SizedBox() : _body())
          : ViewNoData(
              type: NoDataType.NoWiFI,
            ),
    );
  }

  Column _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _titleView(),
              _subTitleView(),
              _infoView(),
              _descriptionTitle(),
              _description(),
              _timeTitle(),
              _time(),
              _locationTitle(),
              _location(),
            ],
          ),
        ),
        SafeArea(
          bottom: true,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              height: 50,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 150,
                    child: GestureDetector(
                      onTap: () {
                        _lianxi();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        decoration: BoxDecoration(
                            color: JobColor.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xFFFD758D).withOpacity(0.2),
                                  offset: Offset(0.0, -1.0),
                                  blurRadius: 9.0,
                                  spreadRadius: 1.0)
                            ]),
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Container(
                          child: Text(
                            '我要咨询',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: JobColor.red),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 229,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _toApply,
                      child: Container(
                        decoration: BoxDecoration(
                          color: JobColor.red,
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFFFD758D),
                                Color(0xFFFCA2A2),
                              ],
                              begin: AlignmentDirectional.bottomStart,
                              end: AlignmentDirectional.topStart),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _isJoin ? '已报名' : '立即报名',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: JobColor.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _location() {
    return Container(
        padding: EdgeInsets.all(16),
        child: Text(
          _model?.tAddress ?? '',
          style: TextStyle(fontSize: 14, color: Color(0xFF6B6A6A)),
        ));
  }

  _locationTitle() {
    return Container(
      padding: EdgeInsets.only(left: 6, top: 4),
      child: ViewTitle(
        title: '工作地点',
      ),
    );
  }

  _time() {
    return Container(
        padding: EdgeInsets.all(16),
        child: Text(
          _model?.tTime ?? '',
          style: TextStyle(fontSize: 14, color: Color(0xFF6B6A6A)),
        ));
  }

  _timeTitle() {
    return Container(
      padding: EdgeInsets.only(
        left: 6,
      ),
      child: ViewTitle(
        title: '工作时间',
      ),
    );
  }

  _description() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Html(
        defaultTextStyle: TextStyle(fontSize: 14, color: Color(0xFF6B6A6A)),
        data: _model?.info ?? '',
      ),
    );
  }

  _descriptionTitle() {
    return Container(
      padding: EdgeInsets.only(left: 6, top: 33),
      child: ViewTitle(
        title: '工作描述',
      ),
    );
  }

  _infoView() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 24),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: <Widget>[
          Container(
            height: 90,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  bottomLeft: Radius.circular(45),
                ),
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFFFB8499),
                    Color(0xFFFCA2A2),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: ClipOval(
                  child: Container(
                    color: JobColor.white.withAlpha(200),
                    child: CachedNetworkImage(
                      imageUrl: _model?.pic ?? '',
                      width: 55,
                      height: 55,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _model?.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: JobColor.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30, top: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                null == _model?.contace
                                    ? ''
                                    : _model.contace.replaceAll(',', ' '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: JobColor.white, fontSize: 14),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _copyMsg();
                              },
                              child: Container(
                                width: 54,
                                height: 26,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: JobColor.white,
                                    borderRadius: BorderRadius.circular(13)),
                                child: Text(
                                  '复制',
                                  style: TextStyle(
                                      color: JobColor.red, fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _titleView() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 14, bottom: 6, right: 15),
      child: Text(
        _model?.title ?? '',
        style: TextStyle(
            fontSize: 18,
            color: Color(0xFF161515),
            fontWeight: FontWeight.w500),
      ),
    );
  }

  _subTitleView() {
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: Row(
        children: <Widget>[
          Text.rich(
            TextSpan(
              text: _model?.reword ?? '--',
              style: JobStyle.moneyStyle,
              children: <TextSpan>[
                TextSpan(text: ' 元/', style: JobStyle.moneyStateStyle),
                TextSpan(
                    text: _model?.danwei ?? '--',
                    style: JobStyle.moneyStateStyle),
              ],
            ),
          ),
          (null == _model?.qixian) ? SizedBox() : _type(_model?.qixian ?? ''),
          (null == _model?.jiesuan) ? SizedBox() : _type(_model?.jiesuan ?? ''),
          (null == _model?.sex) ? SizedBox() : _type(_model?.sex ?? '')
        ],
      ),
    );
  }

  Container _type(String name) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Container(
        color: Color(0xFFF5F5F5),
        child: Text(
          name,
          style: TextStyle(fontSize: 12, color: Color(0xFFB0B0B0)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 3),
      ),
    );
  }
}
