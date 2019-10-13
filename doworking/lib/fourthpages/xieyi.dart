import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class XieYi extends StatefulWidget {
  XieYi({Key key}) : super(key: key);

  _XieYiState createState() => _XieYiState();
}

class _XieYiState extends State<XieYi> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('用户协议'),
      ),
      body: WebView(
        initialUrl: 'http://www.taotaopt.com/index/index/index',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
