import 'package:Uthbay/models/cart_request_model.dart';
import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/provider/grocery_provider.dart';
import 'package:Uthbay/provider/loader_provider.dart';
import 'package:Uthbay/screens/widgets/cart_notify.dart';
import 'package:Uthbay/utilis/ProgressHUD.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  @override
  BaseScreenState createState() => BaseScreenState();
}

class BaseScreenState<T extends BaseScreen> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(builder: (context, loaderModel, child) {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: ProgressHUD(
          child: pageUI(),
          inAsyncCall: loaderModel.isApiCallProcess,
          opacity: 0.3,
        ),
      );
    });
  }

  Widget pageUI() {
    return null;
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.redAccent,
      brightness: Brightness.dark,
      elevation: 0,
      automaticallyImplyLeading: true,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context)),
      title: appTitle(),
      actions: [
        cartNotify(context),
        SizedBox(width: 10),
      ],
    );
  }

  Widget appTitle() {
    return Text(
        Provider.of<GroceryProvider>(context, listen: false)
            .grocery
            .name
            .toString(),
        style: TextStyle(color: Colors.white));
  }
}
