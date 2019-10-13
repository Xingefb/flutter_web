import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class ReData {
  final dynamic code;
  final String text;
  final dynamic info;

  ReData(this.code, this.text, this.info);

  ReData.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        text = json['text'],
        info = json['info'];

  Map<String, dynamic> toJson() => {
        'code': code,
        'text': text,
        'info': info,
      };
}

class BaseNet {
  static BaseNet instance;
  Dio dio;
  BaseOptions options;
  CancelToken cancelToken = CancelToken();

  static final String _baseUrl = 'http://47.96.141.69/';

  static BaseNet getInstance() {
    if (null == instance) instance = BaseNet();
    return instance;
  }

// 拦截添加token
  _configHeaders(RequestOptions options) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('token');
    print('token =>> ' + token);
    if (null != token) {
      options.headers.addAll({'Authorization': token});
    }
  }

  BaseNet() {
    if (null == options) {
      options = BaseOptions(
          baseUrl: _baseUrl,
          //连接服务器超时时间，单位是毫秒.
          connectTimeout: 10000,
          //响应流上前后两次接受到数据的间隔，单位为毫秒。
          receiveTimeout: 5000,
          responseType: ResponseType.json);
    }
    dio = Dio(options);

//添加拦截器
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      _workState();
      _configHeaders(options);
      print("请求之前");
      return options; //continue
    }, onResponse: (Response response) {
      print("响应之前");
      return response; // continue
    }, onError: (DioError e) {
      print("错误之前" + e.message);
      return e; //continue
    }));
  }

  _workState() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      configError(DioError(message: '无网络连接'));
    }
  }

  ReData _configRes(Response response) {
    ReData _data;
    Map<String, dynamic> res;
    print(response.data.runtimeType.toString());
    if (response.data.runtimeType == Map) {
      _data = ReData.fromJson(response.data);
      print('map run type' + _data.info.runtimeType.toString());
    } else if (response.data.runtimeType == String) {
      res = convert.jsonDecode(response.data);
      _data = ReData.fromJson(res);
      print('string run type' + _data.info.runtimeType.toString());
    } else {
      _data = ReData.fromJson(response.data);
      print('else run type' + _data.info.runtimeType.toString());
    }
    return _data;
  }

  /*
   * get请求
   */
  get(url, {Map<String, dynamic> par, options, cancelToken}) async {
    _workState();
    Response response;
    ReData _data;
    try {
      response = await dio.get(url,
          queryParameters: par, options: options, cancelToken: cancelToken);
      print('get res => ' + response.data.toString());
      _data = _configRes(response);
    } on DioError catch (e) {
      configError(e);
    }
    print('get res => ' + response.data.toString());
    return _data;
  }

  /*
   * post请求
   */
  post(url,
      {Map<String, dynamic> parameters, data, options, cancelToken}) async {
    _workState();
    // print('data => ' + data.toString());
    Response response;
    ReData _data;
    try {
      response = await dio.post(url,
          queryParameters: parameters,
          data: data,
          options: options,
          cancelToken: cancelToken);
      // print('post res => ' + response.data.toString());
      _data = _configRes(response);
    } on DioError catch (e) {
      configError(e);
    }
    print('post res => ' + response.data.toString());
    return _data;
  }

  /*
   * put 请求
   */
  put(url,
      {Map<String, dynamic> parameters, data, options, cancelToken}) async {
    _workState();
    Response response;
    ReData _data;
    try {
      response = await dio.put(url,
          queryParameters: parameters,
          data: data,
          options: options,
          cancelToken: cancelToken);
      _data = _configRes(response);
    } on DioError catch (e) {
      configError(e);
    }
    print('put res => ' + response.data.toString());
    return _data;
  }

  /*
   * 下载文件
   */
  downloadFile(urlPath, savePath) async {
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.none) {
    //   configError(DioError(message: '无网络链接'));
    //   return connectivityResult;
    // }
    _workState();
    Response response;
    ReData _data;
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
        //进度
        print("$count $total");
      });
      _data = _configRes(response);
    } on DioError catch (e) {
      configError(e);
    }
    print(response.data.toString());
    return _data;
  }

  /*
   * error统一处理
   */
  void configError(DioError e) {
    String msg;
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      msg = '连接超时';
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      msg = '请求超时';
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      msg = '响应超时';
    } else if (e.type == DioErrorType.RESPONSE) {
      // 此处是错误的返回信息
      Map<String, dynamic> error = convert.jsonDecode(e.response.toString());
      print(error.toString());
      msg = error['message'];
      if (e.response.statusCode == 401) {
        _removeToken();
        msg = null;
      }
    } else if (e.type == DioErrorType.CANCEL) {
      msg = '请求取消';
    } else {
      msg = e.message == '无网络链接' ? '无网络链接' : '响应异常';
    }
    if (null == msg) {
    } else {
      Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER);
    }
    throw e;
  }

  _removeToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('access_token');
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}
