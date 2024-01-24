import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '/../AppLocalizations.dart';
import '/../main.dart';
import '/../utils/AppWidget.dart';
import '../utils/AppBarWidget.dart';

class WebViewPaymentScreen extends StatefulWidget {
  static String tag = '/WebViewPaymentScreen';
  final String? checkoutUrl;

  WebViewPaymentScreen({this.checkoutUrl});

  @override
  WebViewPaymentScreenState createState() => WebViewPaymentScreenState();
}

class WebViewPaymentScreenState extends State<WebViewPaymentScreen> {
  bool mIsError = false;
  late final WebViewController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(onPageFinished: (str) {
        if (mIsError) return;
        if (str.contains('checkout/order-received')) {
          appStore.setLoading(true);
          //toast('Order placed successfully');
          appStore.setCount(0);
          finish(context, true);
        } else {
          appStore.setLoading(false);
        }
      }))
      ..loadRequest(
        Uri.parse(widget.checkoutUrl!),
      );
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: mTop(context, appLocalization.translate('title_payment'),
          showBack: true) as PreferredSizeWidget?,
      body: BodyCornerWidget(
        child: Stack(
          children: [
            WebViewWidget(
              /*
              initialUrl: widget.checkoutUrl,
              javascriptMode: JavascriptMode.unrestricted,
              gestureNavigationEnabled: true,
              onPageFinished: (String url) {
                if (mIsError) return;
                if (url.contains('checkout/order-received')) {
                  appStore.setLoading(true);
                  //toast('Order placed successfully');
                  appStore.setCount(0);
                  finish(context, true);
                } else {
                  appStore.setLoading(false);
                }
              },
              onWebResourceError: (s) {
                mIsError = true;
              },*/
              controller: controller,
            ),
            mProgress().visible(appStore.isLoading).center()
          ],
        ),
      ),
    );
  }
}
