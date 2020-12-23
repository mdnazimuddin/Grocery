import 'dart:ui';

import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/provider/loader_provider.dart';
import 'package:Uthbay/screens/checkout/widgets/checkpoints.dart';
import 'package:Uthbay/utilis/ProgressHUD.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutBasePage extends StatefulWidget {
  @override
  CheckoutBasePageState createState() => CheckoutBasePageState();
}

class CheckoutBasePageState<T extends CheckoutBasePage> extends State<T> {
  int currentPage = 0;
  bool showBackbutton = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Checkout base Page: initState");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(builder: (context, loaderModel, child) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: ProgressHUD(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // CheckPoints(
                //   checkedTill: currentPage,
                //   checkPoints: [
                //     "Shipping",
                //     "Payment",
                //     "Order ",
                //   ],
                //   checkPointFilledColor: Colors.green,
                // ),
                // Divider(color: Colors.grey),
                pageUI(),
              ],
            ),
          ),
          inAsyncCall: loaderModel.isApiCallProcess,
          opacity: 0.3,
        ),
      );
    });
  }

  Widget pageUI() {
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.redAccent,
      brightness: Brightness.dark,
      elevation: 0,
      automaticallyImplyLeading: showBackbutton,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context)),
      title: Text(
        "Checkout",
        style: TextStyle(color: Colors.white),
      ),
      actions: [],
    );
  }
}
