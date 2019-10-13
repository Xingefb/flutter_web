import 'package:doworking/firstpages/page_jobdetail.dart';
import 'package:doworking/models/model_job_cell.dart';
import 'package:doworking/utils/api_go.dart';
import 'package:doworking/utils/base_net.dart';
import 'package:doworking/views/view_collect_cell.dart';
import 'package:doworking/views/view_nodata.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Collections extends StatefulWidget {
  Collections({Key key}) : super(key: key);

  _CollectionsState createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {
  ApiGo _api = ApiGo.shareInstance();
  List _data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    List res = await _api.collectList();
    _data.clear();
    _data.addAll(res);
    setState(() {});
  }

  _cancleCollect(ModelJobCell model) async {
    ReData res = await _api.toCollect(data: {'pid': model.id, 'status': 0});
    if (res.code == '0') {
      _loadData();
    } else {
      Fluttertoast.showToast(msg: res.text, gravity: ToastGravity.CENTER);
    }
  }

  _toDetail(ModelJobCell model,index) async {
    if (null == model.id) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageJobDetail(
          model: model,
          posi: 'collect',
          order: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的收藏'),
      ),
      body: RefreshIndicator(
        child: _data.length < 1
            ? ViewNoData(
                type: NoDataType.NoCollection,
                onTap: () {
                  _loadData();
                },
              )
            : ListView.builder(
                itemCount: _data.length,
                itemBuilder: (BuildContext context, int index) {
                  ModelJobCell model = ModelJobCell.fromJson(_data[index]);
                  return ViewCollectCell(
                    model: model,
                    onTap: () {
                      _toDetail(model,index);
                    },
                    cancnel: () {
                      _cancleCollect(model);
                    },
                  );
                },
              ),
        onRefresh: () {
          return _loadData();
        },
      ),
    );
  }
}
