import 'package:connectivity/connectivity.dart';
import 'package:doworking/firstpages/page_jobdetail.dart';
import 'package:doworking/firstpages/view_job_cell.dart';
import 'package:doworking/models/model_job_cell.dart';
import 'package:doworking/utils/api_go.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:doworking/views/view_nodata.dart';
import 'package:flutter/material.dart';

class PageTypeScreen extends StatefulWidget {
  PageTypeScreen({Key key, this.groupId, this.title}) : super(key: key);
  final int groupId;
  final String title;
  _PageTypeScreenState createState() => _PageTypeScreenState();
}

class _PageTypeScreenState extends State<PageTypeScreen> {
  List _data = [];
  ApiGo _api = ApiGo.shareInstance();
  int _page = 0;
  bool _hWifi = true;
  bool _isLoading = true;

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
    _isLoading = true;
    setState(() {});
    try {
      List data = await _api.homeList(data: {
        'group': widget.groupId,
        'pagecount': 20,
        'pagenumber': _page
      });
      if (_page == 0) {
        _data.clear();
      }
      if (data.length > 19) {
        _page++;
      }
      _data.addAll(data);
      _isLoading = false;
      setState(() {});
    } catch (e) {
      _isLoading = false;
      setState(() {});
    }
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
          posi: widget.groupId,
          order: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JobColor.white,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _hWifi
          ? _body()
          : ViewNoData(
              type: NoDataType.NoWiFI,
              onTap: () {
                _page = 0;
                setState(() {});
                _loadData();
              },
            ),
    );
  }

  _body() {
    return RefreshIndicator(
      child: SafeArea(
        bottom: true,
        top: false,
        child: _isLoading
            ? SizedBox()
            : (_data.length < 1
                ? ViewNoData(
                    type: NoDataType.NoData,
                    onTap: () {
                      _page = 0;
                      setState(() {});
                      _loadData();
                    },
                  )
                : CustomScrollView(
                    slivers: <Widget>[
                      _listView(),
                    ],
                  )),
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
}
