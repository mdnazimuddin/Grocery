import 'package:Uthbay/models/grocery_list.dart';
import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/provider/grocery_provider.dart';
import 'package:Uthbay/screens/order/components/order_details.dart';
import 'package:Uthbay/screens/order/orders_page.dart';
import 'package:Uthbay/screens/payment/payment_screen.dart';
import 'package:Uthbay/screens/product/cart/cart_page.dart';
import 'package:Uthbay/screens/shop/components/customer_profile.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:Uthbay/screens/widgets/cart_notify.dart';
import 'package:Uthbay/utilis/cart_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/dashboard_screen.dart';
import 'components/favourite_screen.dart';

class ShopScreen extends StatefulWidget {
  final GroceryList grocery;
  ShopScreen({this.grocery});
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  GroceryList grocery;
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
    setState(() {
      grocery = Provider.of<GroceryProvider>(context, listen: false).grocery;
      cartProcider();
    });
  }

  cartProcider() {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.fetchCartItems(int.parse(grocery.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      floatingActionButton:
          FloatingActionButton(onPressed: () {}, child: Icon(CartIcons.search)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 10,
        fabLocation: BubbleBottomBarFabLocation.end, //new
        hasNotch: true, //new
        hasInk: true, //new, gives a cute ink effect
        inkColor: Colors.black12, //optional, uses theme color if not specified
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                CartIcons.home,
                color: Colors.black,
              ),
              activeIcon: Icon(
                CartIcons.home,
                color: Colors.redAccent,
              ),
              title: Text("Store")),
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                CartIcons.favourites,
                color: Colors.black,
              ),
              activeIcon: Icon(
                CartIcons.favourites,
                color: Colors.redAccent,
              ),
              title: Text("Favourite")),
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                CartIcons.cart,
                color: Colors.black,
              ),
              activeIcon: Icon(
                CartIcons.cart,
                color: Colors.redAccent,
              ),
              title: Text("Order")),
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                CartIcons.account,
                color: Colors.black,
              ),
              activeIcon: Icon(
                CartIcons.account,
                color: Colors.redAccent,
              ),
              title: Text("Account")),
        ],
        // selectedItemColor: Colors.redAccent,
        // unselectedItemColor: Colors.black,
        // type: BottomNavigationBarType.shifting,
        // currentIndex: _index,
        // onTap: (index) {
        //   setState(() {
        //     _index = index;
        //   });
        // },
      ),
      body: _index == 0
          ? DashboardScreen(
              grocery: widget.grocery,
            )
          : (_index == 1
              ? FavoriteScreen()
              : (_index == 2
                  ? Orderspage()
                  : (_index == 3 ? CustomerProfile() : Container()))),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.redAccent,
      brightness: Brightness.dark,
      elevation: 0,
      automaticallyImplyLeading: true,
      title: Text(
        this.grocery.name.toString(),
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context)),
      actions: [
        cartNotify(context),
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
