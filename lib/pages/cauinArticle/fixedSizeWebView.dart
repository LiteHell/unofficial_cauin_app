import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DefiniteSizeWebView extends StatefulWidget {
  final String html;
  final String baseUrl;
  const DefiniteSizeWebView(
      {super.key, required this.html, required this.baseUrl});

  @override
  State<DefiniteSizeWebView> createState() => _DefiniteSizeWebViewState();
}

class _DefiniteSizeWebViewState extends State<DefiniteSizeWebView> {
  double _height = -1;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    WebViewController? _webviewController = null;
    final html = (context.widget as DefiniteSizeWebView).html;
    final baseUrl = (context.widget as DefiniteSizeWebView).baseUrl;
    return Column(
      children: [
        if (_height < 0) ...const [
          Center(child: CircularProgressIndicator()),
          Padding(padding: EdgeInsets.all(10), child: Text('불러오는 중입니다.'))
        ],
        ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: _height > 0 ? _height : 1,
                maxWidth: MediaQuery.of(context).size.width),
            child: WebView(
              backgroundColor: Colors.transparent,
              javascriptMode: JavascriptMode.unrestricted,
              zoomEnabled: false,
              gestureRecognizers: Set()
                ..add(Factory<LongPressGestureRecognizer>(
                    () => LongPressGestureRecognizer()))
                ..add(Factory<TapGestureRecognizer>(
                    () => TapGestureRecognizer())),
              debuggingEnabled: true,
              onWebViewCreated: ((controller) {
                _webviewController = controller;
                controller.loadHtmlString('''<!DOCTYPE html>
                    <html>
                      <head>
                          <meta name="viewport" content="width=device-width, initial-scale=1.0">
                          <style>
                          html, body {
                            max-width: 100%;
                          }
                          </style>
                        </head>
                        <body>$html</body>
                      </html>''', baseUrl: baseUrl);
              }),
              onPageFinished: ((url) {
                _webviewController?.runJavascriptReturningResult('''(function(){
              var body = document.body,
                  html = document.documentElement;
              
              return Math.max(body.scrollHeight, body.offsetHeight, 
                              html.clientHeight, html.scrollHeight, html.offsetHeight );
            })()''').then((resultString) {
                  int result = int.parse(resultString);
                  setState(() {
                    _height = result.toDouble();
                  });
                });
              }),
            ))
      ],
    );
  }
}
