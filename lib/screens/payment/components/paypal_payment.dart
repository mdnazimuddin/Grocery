import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PaypalPaymentScreen extends StatefulWidget {
  @override
  _PaypalPaymentScreenState createState() => _PaypalPaymentScreenState();
}

class _PaypalPaymentScreenState extends State<PaypalPaymentScreen> {
  // InAppWebViewController webwiew;
  String url = "";
  double progress = 0;
  GlobalKey<ScaffoldState> scaffoldKey;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Paypal payment",
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(
                letterSpacing: 1.3,
              )),
        ),
      ),
      body: Stack(
        children: [
          // InAppWebView(
          //   initialUrl: "https://pub.dev/packages/flutter_inappwebview",
          //   initialOptions: new InAppWebViewGroupOptions(
          //     android: AndroidInAppWebViewOptions(
          //       textZoom: 120,
          //     ),
          //     ios: IOSInAppWebViewOptions(),
          //   ),
          //   onWebViewCreated: (InAppWebViewController controller) {
          //     webwiew = controller;
          //   },
          //   onLoadStart:
          //       (InAppWebViewController controller, String requestURL) {},
          //   onProgressChanged:
          //       (InAppWebViewController controller, int progress) {
          //     setState(() {
          //       this.progress = progress / 100;
          //     });
          //   },
          // ),
          progress < 1
              ? SizedBox(
                  height: 3,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor:
                        Theme.of(context).accentColor.withOpacity(0.2),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
