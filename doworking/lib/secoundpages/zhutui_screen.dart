import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:doworking/firstpages/page_jobdetail.dart';
import 'package:doworking/firstpages/view_job_cell.dart';
import 'package:doworking/models/model_job_cell.dart';
import 'package:doworking/utils/api_go.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:doworking/views/view_nodata.dart';
import 'package:flutter/material.dart';

class ZhutuiScreen extends StatefulWidget {
  ZhutuiScreen({Key key}) : super(key: key);

  _ZhutuiScreenState createState() => _ZhutuiScreenState();
}

class _ZhutuiScreenState extends State<ZhutuiScreen>
    with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  List _types = ['全部兼职', '品牌直招', '其他岗位'];
  List _banner = [];
  List _data = [];
  ApiGo _api = ApiGo.shareInstance();
  int _page = 0;
  bool _hWifi = true;
  List _colors = [
    Color(0xFFFD758D),
    Color(0xFF5BD9FA),
    Color(0xFF7596FD),
  ];
  PageController _pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

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
        _toLoad();
      }
      setState(() {});
    });
    _toLoad();
  }

  _toLoad() async {
    await _listBanner();
    await _loadData();
  }

  _listBanner() async {
    List data = await _api
        .homeList(data: {'group': 5, 'pagecount': 20, 'pagenumber': _page});
    if (_page == 0) {
      _banner.clear();
    }
    if (_banner.length > 19) {
      _page++;
    }
    _banner.addAll(data);
    setState(() {});
  }

  _loadData() async {
    print('current index = > ' +
        _currentIndex.toString() +
        'page' +
        _page.toString());
    List data = await _api.homeList(data: {
      'group': _currentIndex + 6,
      'pagecount': 20,
      'pagenumber': _page
    });
    // if (_page == 0) {
    //   setState(() {
    //     _data.clear();
    //   });
    // }

    if (data.length > 19) {
      _page++;
    }
    _data.addAll(data);
    setState(() {});
  }

  _switchIndex(index) {
    _currentIndex = index;
    _page = 0;
    _data.clear();
    setState(() {});
    _loadData();
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
          posi: _currentIndex + 6,
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
          SliverToBoxAdapter(
            child: _topList(),
          ),
          SliverToBoxAdapter(
            child: _centerList(),
          ),
          _listView(),
        ],
      ),
      onRefresh: () => _toLoad(),
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

  _topList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width,
      height: 202,
      child: ListView.builder(
        itemCount: _banner.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          ModelJobCell model = ModelJobCell.fromJson(_banner[index]);
          return GestureDetector(
            onTap: () {
              _toJobDetail(model, index);
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: JobColor.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 168,
                height: 182,
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: model?.bPic ?? '',
                        fit: BoxFit.fill,
                        width: 168,
                        height: 182,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 16, top: 16, right: 16),
                          child: Text(
                            model?.title ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 17,
                                color: JobColor.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 16, top: 5, right: 2),
                              child: Text(
                                model?.reword,
                                style: TextStyle(
                                    fontSize: 17,
                                    color: JobColor.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5, right: 16),
                              child: Text(
                                '元/${model?.danwei}',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: JobColor.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 6, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              _type(model?.qixian ?? ''),
                              _type(model?.jiesuan ?? ''),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Container _type(String name) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Container(
        decoration: BoxDecoration(
            color: JobColor.white, borderRadius: BorderRadius.circular(2)),
        child: Text(
          name,
          style: TextStyle(fontSize: 12, color: JobColor.red),
        ),
        padding: EdgeInsets.symmetric(horizontal: 3),
      ),
    );
  }

  _centerList() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 84,
      padding: EdgeInsets.only(left: 12, right: 8),
      child: ListView.builder(
        itemCount: _types.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              _switchIndex(index);
            },
            child: Container(
              width: (width - 20) / 3,
              height: width / 375 * 64,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Image.asset(
                    _currentIndex == index
                        ? 'assets/images/current_index@2x.png'
                        : 'assets/images/other_index@2x.png',
                    fit: BoxFit.fitWidth,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ClipOval(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: _currentIndex == index
                                        ? JobColor.white
                                        : _colors[index],
                                    width: 2),
                                borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 6, bottom: 3),
                          child: Text(
                            _types[index] + ' ',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: _currentIndex == index
                                    ? JobColor.white
                                    : JobColor.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
