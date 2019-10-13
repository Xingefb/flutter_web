import 'package:cached_network_image/cached_network_image.dart';
import 'package:doworking/fourthpages/person_center.dart';
import 'package:doworking/models/model_user.dart';
import 'package:doworking/models/model_user_jl.dart';
import 'package:doworking/utils/all_eventbus.dart';
import 'package:doworking/utils/api_go.dart';
import 'package:doworking/utils/base_net.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:doworking/views/view_input_view.dart';
import 'package:doworking/views/view_msg_input.dart';
import 'package:doworking/views/view_msg_select.dart';
import 'package:doworking/views/view_title.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PageWodejianli extends StatefulWidget {
  PageWodejianli({Key key, this.model}) : super(key: key);
  final ModelUser model;
  _PageWodejianliState createState() => _PageWodejianliState();
}

class _PageWodejianliState extends State<PageWodejianli> {
  ApiGo _api = ApiGo.shareInstance();
  ScrollController _controller = ScrollController();
  ModelUserJl _model;
  String _background = '';
  String _info = '';
  String _school = '';
  String _sTime = '';
  String _xueli = '';
  Color _navBarColor;
  /*
   工作经历 background = Uuuu;
   自我评价 info = Tatty;
   入学年份 "s_time" = 1970;
   学校名称 school = "If you\U2019re ";
   学历 xueli = "\U535a\U58eb\U53ca\U4ee5\U4e0a";
   */

  @override
  void initState() {
    super.initState();
    // _controller.addListener(() {
    //   print(_controller.offset.toString());
    //   _navBarColor = Colors.red.withOpacity(_controller.offset);
    //   setState(() {});
    // });
    eventBus.on<RefreshUserInfoEventBus>().listen((data) {
      if (data.isRefresh) {
        _loadData();
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _save() async {
    print(_school);
    ReData res = await _api.pushUserJl(data: {
      'background': _background,
      'info': _info,
      's_time': _sTime,
      'school': _school,
      'xueli': _xueli
    });
    if (res.code == '0') {
      Fluttertoast.showToast(msg: '保存成功', gravity: ToastGravity.CENTER);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: res.text, gravity: ToastGravity.CENTER);
    }
  }

  _loadData() async {
    ReData res = await _api.getUserJl();
    if (res.code == '0') {
      _model = ModelUserJl.fromJson(res.info);
      _background = _model?.background ?? '';
      _info = _model?.info ?? '';
      _school = _model?.school ?? '';
      _sTime = _model?.sTime ?? '';
      _xueli = _model?.xueli ?? '';
      setState(() {});
    } else {
      // Fluttertoast.showToast(msg: res.text, gravity: ToastGravity.CENTER);
    }
  }

  _toPersonCenter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonCenter(
          model: widget.model,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: JobColor.white,
      body: Stack(
        children: <Widget>[
          _body(width),
          Positioned(
            child: Container(
                color: _navBarColor,
                height: 44 + statusBarHeight,
                padding: EdgeInsets.only(top: statusBarHeight),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: JobColor.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '我的简历',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: JobColor.white),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _save();
                      },
                      child: Padding(
                        child: Text(
                          '保存',
                          style: TextStyle(color: JobColor.white, fontSize: 15),
                        ),
                        padding: EdgeInsets.only(right: 15),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
      // null == _model ? _noData(width) :
    );
  }

  _body(width) {
    return CustomScrollView(
      controller: _controller,
      // physics: AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        _topView(width),
        _userInfo(),
        _titleView(),
        _titleBody(),
        _jobDescTitle(),
        _jobDescBody(),
        _personDescTitle(),
        _personDescBody(),
      ],
    );
  }

  _personDescBody() {
    return SliverToBoxAdapter(
      child: Container(
        child: ViewInputView(
          msg: _info,
          hintText: '请对自己做最真实的评价',
          onConfirm: (String text) {
            _info = text.trim();
            // setState(() {});
          },
        ),
      ),
    );
  }

  _personDescTitle() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(
          left: 12,
          top: 8,
        ),
        child: ViewTitle(
          title: '个人评价',
        ),
      ),
    );
  }

  _jobDescBody() {
    return SliverToBoxAdapter(
      child: Container(
        child: ViewInputView(
          msg: _background,
          hintText: '请对你的工作经历进行详情的描述',
          onConfirm: (String text) {
            _background = text.trim();
            // setState(() {});
          },
        ),
      ),
    );
  }

  _jobDescTitle() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(
          left: 12,
        ),
        child: ViewTitle(
          title: '工作描述',
        ),
      ),
    );
  }

  _titleBody() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          children: <Widget>[
            ViewMsgSelect(
              data: List.generate(DateTime.now().year - 1977 + 1, (index) {
                return index + 1977;
              }),
              msg: _sTime,
              title: '入学年份',
              hintText: '请选择您的毕业年份',
              height: 50,
              onConfirm: (String text) {
                // _sTime = int.parse(text);
                _sTime = text;
                setState(() {});
                print(text);
              },
            ),
            ViewMsgSelect(
              data: ['大专以下', '大专', '本科', '研究生', '博士', '博士以上'],
              msg: _xueli,
              title: '学历',
              hintText: '请选择您的最高学历',
              height: 50,
              onConfirm: (text) {
                _xueli = text;
                setState(() {});
                print(text);
              },
            ),
            ViewMsgInput(
              title: '学校名称',
              msg: _school,
              hintText: '请输入毕业院校',
              height: 50,
              // limitLength: 15,
              onConfirm: (String text) {
                _school = text.trim();
                // setState(() {});
                print(text);
              },
            ),
          ],
        ),
      ),
    );
  }

  _titleView() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(left: 12, top: 20),
        child: ViewTitle(
          title: '教育经历',
        ),
      ),
    );
  }

  SliverToBoxAdapter _userInfo() {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () {
          _toPersonCenter();
        },
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    (null == widget.model?.nickname ||
                            widget.model.nickname.isEmpty)
                        ? '编辑信息'
                        : widget.model?.nickname,
                    style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFF161515),
                        fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 7, top: 8),
                      child: Text(
                        (widget.model?.age ?? 0).toString() +
                            '岁 ' +
                            (widget.model?.sex == 1 ? '女' : '男'),
                        style:
                            TextStyle(color: Color(0xFFA0A0A0), fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                (null == widget.model?.sign || widget.model.sign.isEmpty)
                    ? '添加个性签名彰显自我'
                    : widget.model?.sign,
                style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Positioned _navbar(statusBarHeight) {
    return Positioned(
      child: Container(
          padding: EdgeInsets.only(top: statusBarHeight),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: JobColor.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '我的简历',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: JobColor.white),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _save();
                },
                child: Padding(
                  child: Text(
                    '保存',
                    style: TextStyle(color: JobColor.white, fontSize: 15),
                  ),
                  padding: EdgeInsets.only(right: 15),
                ),
              ),
            ],
          )),
    );
  }

  SliverToBoxAdapter _topView(width) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return SliverToBoxAdapter(
      child: Stack(
        children: <Widget>[
          Container(
            height: width * 150 / 375 + statusBarHeight,
            width: width,
          ),
          Container(
            height: width * 100 / 375 + statusBarHeight,
            width: width,
            child: Image.asset(
              'assets/images/banner_back@2x.png',
              fit: BoxFit.fill,
            ),
          ),
          // _navbar(statusBarHeight),
          Column(
            children: <Widget>[
              Container(
                height: width * 60 / 375 + statusBarHeight,
                width: width,
              ),
              Container(
                height: 90,
                width: 90,
                child: ClipOval(
                    child: CachedNetworkImage(
                  imageUrl: widget.model.img ?? '',
                  placeholder: (context, url) {
                    return Image.asset(
                      'assets/images/默认头像@2x.png',
                      width: 90,
                      height: 90,
                    );
                  },
                )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
