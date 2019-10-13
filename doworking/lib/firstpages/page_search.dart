import 'package:dio/dio.dart';
import 'package:doworking/firstpages/page_jobdetail.dart';
import 'package:doworking/firstpages/view_job_cell.dart';
import 'package:doworking/models/model_job_cell.dart';
import 'package:doworking/utils/api_go.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PageSearch extends StatefulWidget {
  PageSearch({Key key}) : super(key: key);

  _PageSearchState createState() => _PageSearchState();
}

class _PageSearchState extends State<PageSearch> {
  TextEditingController _textEditingController = TextEditingController();
  ScrollController _controller = ScrollController();
  FocusNode _focusNode = FocusNode();
  String _str = '搜索你想要的兼职';
  String _searchText;
  int _page = 0;
  List _data = [];
  List _searchs = [
    '美工',
    '打字员',
    '售货员',
    '长期招聘',
  ];

  ApiGo _api = ApiGo.shareInstance();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _textEditingController.dispose();
  }

  _loadData() async {
    if (null == _searchText.trim() || _searchText.trim().isEmpty) {
      return;
    } else {
      try {
        List data = await _api
            .searchList(data: {'search': _searchText, 'pagenumber': _page});
        if (_page == 0) {
          if (data.length < 1) {
            _textEditingController.clear();
            _str = '搜索你想要的兼职';
            Fluttertoast.showToast(
                msg: '没有相关内容，请重新搜索', gravity: ToastGravity.CENTER);
          }
          _data.clear();
        }
        if (data.length > 19) {
          _page++;
        }
        _data.addAll(data);
        setState(() {});
      } on DioError catch (e) {
        debugPrint('list 请求失败' + e.message);
      }
    }
  }

  _toJobDetail(ModelJobCell model, index) async {
    // if (null == model.pid || null == model.id) {
    //   return;
    // }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageJobDetail(
          model: model,
          posi: 'search',
          order: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JobColor.white,
      body: CustomScrollView(
        controller: _controller,
        slivers: <Widget>[
          // search bar
          _searchBar(),
          // SliverToBoxAdapter(
          //   child: SizedBox(
          //     height: 20,
          //   ),
          // ),
          (_data == null || _data.isEmpty) ? _normalView() : _listView(),
        ],
      ),
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

  SliverToBoxAdapter _searchBar() {
    // search bar
    return SliverToBoxAdapter(
      child: SafeArea(
        top: true,
        bottom: false,
        child: Container(
          padding: EdgeInsets.only(left: 10, top: 4),
          width: AppBar().preferredSize.width,
          child: Container(
            height: 38,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFFF5F5F5)),
                      child: Stack(
                        alignment: AlignmentDirectional.centerStart,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image.asset(
                                'assets/images/search@2x.png',
                                width: 14,
                                fit: BoxFit.fitWidth,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Text(
                                  _str,
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xFF8A8A8A)),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, bottom: 2),
                            child: TextField(
                              controller: _textEditingController,
                              focusNode: _focusNode,
                              style: TextStyle(fontSize: 14),
                              textInputAction: TextInputAction.search,
                              onSubmitted: (text) {
                                setState(() {
                                  _page = 0;
                                  _searchText = text;
                                });
                                _loadData();
                              },
                              onChanged: (text) {
                                setState(() {
                                  _str = text.length > 0 ? '' : '请输入您要搜索的内容';
                                  if (text.length < 1) {
                                    _page = 0;
                                    _data.clear();
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                // contentPadding: EdgeInsets.only(bottom: 0)
                                // hintText: '搜索你想要的兼职',
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 60,
                    child: Text(
                      '取消',
                      style: TextStyle(fontSize: 15, color: JobColor.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _searchItem(title) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _focusNode.unfocus();
        _searchText = title;
        _str = '';
        _textEditingController.text = title;
        setState(() {});
        _loadData();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1),
          color: Color(0xFFF9F8F8),
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 13, color: JobColor.black),
        ),
      ),
    );
  }

  SliverToBoxAdapter _normalView() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                '热门搜索',
                style: TextStyle(fontSize: 14, color: Color(0xFF8A8A8A)),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.start,
                children: List.generate(
                  _searchs.length,
                  (index) {
                    String title = _searchs[index];
                    return _searchItem(title);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
