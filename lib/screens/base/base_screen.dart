import 'package:Uthbay/models/cart_request_model.dart';
import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/provider/loader_provider.dart';
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
        appBar: _buildAppBar(),
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

  Widget _buildAppBar() {
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
      title: applogo(),
      actions: [
        Icon(Icons.notifications_none, color: Colors.white),
        SizedBox(width: 10),
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Colors.white,
              onPressed: () {},
            ),
            Provider.of<CartProvider>(context, listen: false)
                        .cartItems
                        .length ==
                    0
                ? new Container()
                : new Positioned(
                    top: 4.0,
                    right: 4.0,
                    child: new Stack(
                      children: [
                        Icon(
                          Icons.brightness_1,
                          size: 20.0,
                          color: Colors.green[800],
                        ),
                        new Positioned(
                          top: 4.0,
                          right: 5.0,
                          child: Center(
                            child: Text(
                              Provider.of<CartProvider>(context, listen: false)
                                  .cartItems
                                  .length
                                  .toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      ],
                    ))
          ],
        ),
        SizedBox(width: 10),
      ],
    );
  }

  Widget applogo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .3,
      child: Image.asset('assets/logo/uthbay-white.png', fit: BoxFit.cover),
    );
  }
}
