// import 'dart:io';

import 'package:doworking/utils/base_net.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert' as convert;

class ApiGo {
  static ApiGo instance;
  BaseNet _http;
  static shareInstance() {
    if (null == instance) {
      instance = ApiGo();
    }
    return instance;
  }

  ApiGo() {
    _http = BaseNet.getInstance();
  }

  ///   idfa
  pushIdfa({data}) async {
    await _http.post('index/idfa/index', data: data);
  }

  /// banner
  banner() async {
    ReData data = await _http.get('index/position/pic');
    List res = data.info;
    return res;
  }

  /// home job list
  homeList({data}) async {
    ReData res = await _http.get('index/position/posilist', par: data);
    return res.info;
  }

  /// search
  searchList({data}) async {
    ReData res = await _http.get('index/position/posilist', par: data);
    return res.info;
  }

  /// job detail
  jobDetail({data}) async {
    ReData res = await _http.get('index/position/posiinfo', par: data);
    return res.info;
  }

  /// phone get code
  getCode({data}) async {
    ReData res = await _http.get('index/user/sendcode', par: data);
    return res;
  }

  /// login
  login({data}) async {
    ReData res = await _http.post('index/user/codelogin', data: data);
    return res.info;
  }

  /// get user info
  getUserInfo() async {
    ReData res = await _http.post(
      'index/user/userinfo',
    );
    return res.info;
  }

  updateCopy({data}) async {
    ReData res = await _http.get('index/position/copycount', par: data);
    return res.info;
  }

  /// join list
  getJoinList({data}) async {
    ReData res = await _http.get('index/join/joinlist', par: data);
    return res.info;
  }

  /// lianxiwomen
  lianxiwomen() async {
    ReData res = await _http.get(
      'index/position/lianxi',
    );
    return res.info;
  }

  /// join job
  toJoinJob({data}) async {
    ReData res = await _http.get('index/join/join', par: data);
    return res;
  }

  /// to collect
  toCollect({data}) async {
    ReData res = await _http.get('index/collect/collect', par: data);
    return res;
  }

  /// get user info
  getUserJl() async {
    ReData res = await _http.get('index/user/resume');
    return res;
  }

  /// push user info jianli
  pushUserJl({data}) async {
    ReData res = await _http.post('index/user/updresume', data: data);
    return res;
  }

  /// collect list
  collectList({data}) async {
    ReData res = await _http.post('index/collect/collist', data: data);
    return res.info;
  }

  /// push user info
  pushUserInfo({data}) async {
    ReData res = await _http.post('index/user/updateinfo', data: data);
    return res;
  }

  /// push yijian
  pushYijian({data}) async {
    ReData res = await _http.post('index/user/addyj', data: data);
    return res;
  }
}
