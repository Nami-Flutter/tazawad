import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '/../utils/AppWidget.dart';
import '../utils/AppBarWidget.dart';

// ignore: must_be_immutable
class WebViewExternalProductScreen extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String? mExternal_URL;
  final String? title;

  // ignore: non_constant_identifier_names
  WebViewExternalProductScreen({Key? key, this.mExternal_URL, this.title})
      : super(key: key);

  @override
  _WebViewExternalProductScreenState createState() =>
      _WebViewExternalProductScreenState();
}

class _WebViewExternalProductScreenState
    extends State<WebViewExternalProductScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate())
      ..loadRequest(Uri.parse(widget.mExternal_URL!));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: mTopNew(context,
            widget.title.validate().isNotEmpty ? widget.title.validate() : '',
            showBack: true) as PreferredSizeWidget?,
        body: BodyCornerWidget(
          child: Builder(
            builder: (context) {
              var mIsError = false;
              return WebViewWidget(
                controller: controller,
                 /* initialUrl: widget.mExternal_URL,
                  javascriptMode: JavascriptMode.unrestricted,
                  gestureNavigationEnabled: true,
                  onPageFinished: (String url) {
                    if (mIsError) return;
                  },
                  onWebResourceError: (s) {
                    mIsError = true;
                  }*/
              );
            },
          )
        ),
      ),
    );
  }
}
