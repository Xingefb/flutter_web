import 'package:doworking/firstpages/page_jobdetail.dart';
import 'package:doworking/models/model_job_cell.dart';
import 'package:doworking/utils/all_eventbus.dart';
import 'package:doworking/utils/api_go.dart';
import 'package:doworking/utils/base_net.dart';
import 'package:doworking/views/alert_colse.dart';
import 'package:doworking/views/alert_lianxi.dart';
import 'package:doworking/views/view_nodata.dart';
import 'package:doworking/views/view_types_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_umplus/flutter_umplus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:um_plugin/um_plugin.dart';

class ViewTypesScreen extends StatefulWidget {
  ViewTypesScreen({Key key, this.index}) : super(key: key);
  // 0 全部 1 已报名 2 已录取 3 已完成
  final int index;
  _ViewTypesScreenState createState() => _ViewTypesScreenState();
}

class _ViewTypesScreenState extends State<ViewTypesScreen>
    with AutomaticKeepAliveClientMixin {
  ApiGo _api = ApiGo.shareInstance();
  int _page = 0;
  List _data = [];

  @override
  void initState() {
    super.initState();
    eventBus.on<CancleApply>().listen((onData) {
      if (onData.isCancle) {
        _loadData();
      }
    });
    _loadData();
  }

  _loadData() async {
    List data =
        await _api.getJoinList(data: {'page': _page, 'status': widget.index});
    if (_page == 0) {
      _data.clear();
    }
    if (data.length > 19) {
      _page++;
    }
    if (data.length > 0) {
      _data.addAll(data);
    }
    setState(() {});
  }

  _toJobDetail(ModelJobCell model, index) {
    if (null == model?.id) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageJobDetail(
          model: model,
          posi: 'apply',
          order: index,
        ),
      ),
    );
  }

  _cancle(ModelJobCell model) async {
    ReData res = await _api
        .toJoinJob(data: {'pid': model?.pid ?? model.id, 'status': 0});
    print(res.text);
    if (res.code == '0') {
      _page = 0;
      setState(() {});
      _loadData();
      eventBus.fire(CancleApply(true));
    } else {
      Fluttertoast.showToast(msg: res.text, gravity: ToastGravity.CENTER);
    }
  }

  _showCancleAlert(ModelJobCell model) async {
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertClose(
          text: '真的要放弃这个职位吗？',
          onTap: () {
            _cancle(model);
          },
        );
      },
    );
  }

  _lianxi(ModelJobCell model) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String imei = pref.getString('imei');
    String idfa = pref.getString('idfa');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertLianxi(
            text: model.contace.replaceAll(',', ' '),
            copyMsg: () {
              _api.updateCopy(
                  data: {'pid': model.id, 'idfa': idfa, 'imei': imei});
              // UmPlugin.addEvent('CopyJobPoint', label: model.id.toString());
              FlutterUmplus.event('CopyJobPoint', label: model.id.toString());
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () {
        _page = 0;
        setState(() {});
        return _loadData();
      },
      child: _data.length < 1
          ? ViewNoData(
              type: NoDataType.NoData,
            )
          : ListView.builder(
              itemCount: _data.length,
              itemBuilder: (BuildContext context, int index) {
                ModelJobCell model = ModelJobCell.fromJson(_data[index]);
                return ViewTypesCell(
                  type: widget.index,
                  model: model,
                  onTap: () {
                    _toJobDetail(model, index);
                  },
                  onCancle: () {
                    _showCancleAlert(model);
                  },
                  onLianxi: () {
                    _lianxi(model);
                  },
                );
              },
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
