import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/screens/product/cart/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

Widget cartNotify(BuildContext context) {
  return Consumer<CartProvider>(builder: (context, cartProvider, child) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.shopping_cart),
          color: Colors.white,
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft, child: CartPage()));
          },
        ),
        cartProvider.cartItems.length == 0
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
                          cartProvider.cartItems.length.toString(),
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
    );
  });
}
