import 'dart:ui';

import 'package:Uthbay/models/cart_request_model.dart';
import 'package:Uthbay/models/cart_response_model.dart';
import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/provider/loader_provider.dart';
import 'package:Uthbay/screens/product/widgets/cart_product.dart';
import 'package:Uthbay/utilis/ProgressHUD.dart';
import 'package:Uthbay/utilis/cart_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  final String groceryId;
  CartPage({this.groceryId});
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var cartItemList = Provider.of<CartProvider>(context, listen: false);
      cartItemList.resetStreams();
      cartItemList.fetchCartItems(int.parse(widget.groceryId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(builder: (context, loaderModel, child) {
      return Scaffold(
          body: ProgressHUD(
        child: _cartItemsList(),
        inAsyncCall: loaderModel.isApiCallProcess,
        opacity: 0.3,
      ));
    });
    // return CartProduct(data: cartItem);
  }

  Widget _cartItemsList() {
    return new Consumer<CartProvider>(
      builder: (context, cartModel, child) {
        if (cartModel.cartItems != null && cartModel.cartItems.length > 0) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.start,

                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: cartModel.cartItems.length,
                      itemBuilder: (context, index) {
                        print(cartModel.cartItems[index]);
                        return CartProduct(
                          data: cartModel.cartItems[index],
                          groceryId: widget.groceryId,
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Icon(
                                Icons.sync,
                                color: Colors.white,
                              ),
                              Text(
                                "Update Cart",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          onPressed: () {
                            Provider.of<LoaderProvider>(context, listen: false)
                                .setLoadingStatus(true);
                            var cartProvider = Provider.of<CartProvider>(
                                context,
                                listen: false);
                            cartProvider.updateCart(
                              int.parse(widget.groceryId),
                              (val) {
                                Provider.of<LoaderProvider>(context,
                                        listen: false)
                                    .setLoadingStatus(false);
                                print(val);
                              },
                            );
                          },
                          padding: EdgeInsets.all(5),
                          color: Colors.green,
                          shape: StadiumBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "\$${cartModel.totalAmount}",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        FlatButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Checkout',
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(Icons.chevron_right, color: Colors.white)
                            ],
                          ),
                          onPressed: () {},
                          padding: EdgeInsets.all(15),
                          color: Colors.redAccent,
                          shape: StadiumBorder(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
