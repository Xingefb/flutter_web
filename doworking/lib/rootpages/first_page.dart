import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:doworking/firstpages/page_jobdetail.dart';
import 'package:doworking/firstpages/page_search.dart';
import 'package:doworking/firstpages/page_typescreen.dart';
import 'package:doworking/firstpages/view_job_cell.dart';
import 'package:doworking/models/model_job_cell.dart';
import 'package:doworking/r.dart';
import 'package:doworking/utils/api_go.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:doworking/views/view_nodata.dart';
import 'package:doworking/views/view_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class FirstPage extends StatefulWidget {
  FirstPage({Key key}) : super(key: key);
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController _controller = ScrollController();
  SwiperController _swiperController = SwiperController();
  ApiGo _api = ApiGo.shareInstance();
  List _data = [];
  List _banner = [];
  int _page = 0;
  bool _hWifi = true;
  List _types = ['首选高薪', '当日结算', '长期稳定'];
  List _styles = [
    TextStyle(fontSize: 15, color: JobColor.red, fontWeight: FontWeight.w500),
    TextStyle(fontSize: 15, color: JobColor.blue, fontWeight: FontWeight.w500),
    TextStyle(
        fontSize: 15, color: JobColor.purple, fontWeight: FontWeight.w500),
  ];
  List _icons = [R.img1, R.img2, R.img3];
  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (ConnectivityResult.none == result) {
        _hWifi = false;
      } else {
        _hWifi = true;
        _loadData();
      }
      setState(() {});
    });
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _swiperController.dispose();
  }

  _loadData() async {
    await _loadBanner();
    await _loadList();
  }

  _loadList() async {
    List data = await _api
        .homeList(data: {'group': 1, 'pagecount': 20, 'pagenumber': _page});
    if (_page == 0) {
      _data.clear();
    }
    if (data.length > 19) {
      _page++;
    }
    _data.addAll(data);
    setState(() {});
  }

  _loadBanner() async {
    List data = await _api.banner();
    _banner.clear();
    _banner.addAll(data);
    setState(() {});
    print('banner length ' + data.length.toString());
  }

  _toJobDetail(ModelJobCell model, index) async {
    if (null == model.pid || null == model.id) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageJobDetail(
          model: model,
          posi: '1',
          order: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _hWifi
          ? _body(width)
          : ViewNoData(
              type: NoDataType.NoWiFI,
              onTap: () {
                _loadData();
              },
            ),
    );
  }

  _body(width) {
    return RefreshIndicator(
      child: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _controller,
        slivers: <Widget>[
          _topView(width),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
          _swiper(width),
          _titleView(),
          _listView(),
        ],
      ),
      onRefresh: () => _loadData(),
    );
  }

  SliverToBoxAdapter _titleView() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(left: 16, bottom: 4, right: 16, top: 30),
        child: ViewTitle(
          title: '热门推荐',
        ),
      ),
    );
  }

  SliverToBoxAdapter _swiper(width) {
    return SliverToBoxAdapter(
      child: Container(
        height: 100,
        child: _banner.length > 0
            ? Swiper(
                controller: _swiperController,
                onTap: (index) {
                  ModelJobCell model = ModelJobCell.fromJson(_banner[index]);
                  _toJobDetail(model, index);
                },
                autoplay: true,
                itemCount: _banner.length,
                viewportFraction: _banner.length > 0 ? 0.8 : 1,
                scale: _banner.length > 0 ? (322 / 375) : 1,
                itemBuilder: (context, index) {
                  ModelJobCell model = ModelJobCell.fromJson(_banner[index]);
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: model?.pic ?? '',
                    ),
                  );
                },
              )
            : SizedBox(),
      ),
    );
  }

  SliverToBoxAdapter _topView(width) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return SliverToBoxAdapter(
      child: Stack(
        children: <Widget>[
          Container(
            height: width * 120 / 375 + statusBarHeight,
            width: width,
          ),
          Container(
            height: width * 90 / 375 + statusBarHeight,
            width: width,
            child: Image.asset(
              'assets/images/banner_back@2x.png',
              fit: BoxFit.fill,
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                height: width * 65 / 375 + statusBarHeight,
                width: width,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_types.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PageTypeScreen(
                                      groupId: index + 2,
                                      title: _types[index],
                                    )));
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: width / 375 * 115,
                          height: width / 375 * 57,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            // color: JobColor.line,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Image.asset(
                                _icons[index],
                                fit: BoxFit.fill,
                              ),
                              Text(
                                _types[index],
                                style: _styles[index],
                              ),
                            ],
                          )),
                    );
                  }),
                ),
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '桃淘兼职',
                    style: TextStyle(
                        color: JobColor.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 45,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PageSearch()));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/search@2x.png',
                              width: 14,
                              fit: BoxFit.fitWidth,
                            ),
                          ],
                        ),
                        height: 30,
                        decoration: BoxDecoration(
                            color: JobColor.white,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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

  @override
  bool get wantKeepAlive => true;
}
