import 'package:connectivity/connectivity.dart';
import 'package:doworking/firstpages/page_jobdetail.dart';
import 'package:doworking/firstpages/view_job_cell.dart';
import 'package:doworking/models/model_job_cell.dart';
import 'package:doworking/utils/api_go.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:doworking/views/view_nodata.dart';
import 'package:flutter/material.dart';

class JipinScreen extends StatefulWidget {
  JipinScreen({Key key}) : super(key: key);

  _JipinScreenState createState() => _JipinScreenState();
}

class _JipinScreenState extends State<JipinScreen>
    with AutomaticKeepAliveClientMixin {
  List _data = [];
  ApiGo _api = ApiGo.shareInstance();
  int _page = 0;
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
    _loadData();
  }

  _loadData() async {
    List data = await _api
        .homeList(data: {'group': 9, 'pagecount': 20, 'pagenumber': _page});
    if (_page == 0) {
      _data.clear();
    }
    if (data.length > 19) {
      _page++;
    }
    _data.addAll(data);
    setState(() {});
  }

  _toJobDetail(ModelJobCell model, index) async {
    if (null == model.pid) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageJobDetail(
          model: model,
          posi: 9,
          order: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: JobColor.white,
      body: _hWifi
          ? _body()
          : ViewNoData(
              type: NoDataType.NoWiFI,
            ),
    );
  }

  _body() {
    return RefreshIndicator(
      child: CustomScrollView(
        slivers: <Widget>[
          // SliverToBoxAdapter(
          //   child: Padding(
          //     child: Text(
          //       '急聘上岗',
          //       style: TextStyle(
          //           color: JobColor.black,
          //           fontSize: 17,
          //           fontWeight: FontWeight.w500),
          //     ),
          //     padding: EdgeInsets.only(left: 17, top: 23, bottom: 20),
          //   ),
          // ),
          _listView(),
        ],
      ),
      onRefresh: () => _loadData(),
    );
  }

  SliverList _listView() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          ModelJobCell model = ModelJobCell.fromJson(_data[index]);
          return ViewJobCell(
            model: model,
            onTap: () {
              _toJobDetail(model, index);
            },
          );
        },
        childCount: _data.length,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
