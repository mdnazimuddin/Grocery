import 'dart:ui';

import 'package:Uthbay/models/grocery_list.dart';
import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/screens/product/cart/cart_page.dart';
import 'package:Uthbay/utilis/cart_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/dashboard_screen.dart';

class ShopScreen extends StatefulWidget {
  final GroceryList grocery;
  ShopScreen({@required this.grocery});
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  _ShopScreenState();
  int _index = 0;
  // List<Widget> _widgetList = [
  //   DashboardScreen(url),
  //   DashboardScreen(url),
  //   DashboardScreen(url),
  //   DashboardScreen(url),
  // ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(CartIcons.home), label: "Store"),
          BottomNavigationBarItem(
              icon: Icon(CartIcons.favourites), label: "Favourite"),
          BottomNavigationBarItem(icon: Icon(CartIcons.cart), label: "Order"),
          BottomNavigationBarItem(
              icon: Icon(CartIcons.account), label: "Account")
        ],
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.shifting,
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
      body: _index == 0
          ? DashboardScreen(
              grocery: widget.grocery,
            )
          : (_index == 1
              ? DashboardScreen(grocery: widget.grocery)
              : (_index == 2
                  ? CartPage(
                      groceryId: this.widget.grocery.id,
                    )
                  : (_index == 3
                      ? DashboardScreen(grocery: widget.grocery)
                      : Container()))),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.redAccent,
      brightness: Brightness.dark,
      elevation: 0,
      automaticallyImplyLeading: true,
      title: Text(
        this.widget.grocery.name.toString(),
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context)),
      actions: [
        Icon(Icons.notifications_none, color: Colors.white),
        SizedBox(width: 10),
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Colors.white,
              onPressed: () {
                CartPage(groceryId: this.widget.grocery.id);
              },
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
                    ),
                  )
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
