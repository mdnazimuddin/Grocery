import 'package:Uthbay/utilis/cart_icons.dart';
import 'package:flutter/material.dart';

import 'components/dashboard_screen.dart';

class ShopScreen extends StatefulWidget {
  final String url;
  ShopScreen(this.url);
  @override
  _ShopScreenState createState() => _ShopScreenState(this.url);
}

class _ShopScreenState extends State<ShopScreen> {
  String url;
  _ShopScreenState(this.url);
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
    this.url = widget.url;
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
          ? DashboardScreen(url)
          : (_index == 1
              ? DashboardScreen(url)
              : (_index == 2
                  ? DashboardScreen(url)
                  : (_index == 3 ? DashboardScreen(url) : Container()))),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.redAccent,
      brightness: Brightness.dark,
      elevation: 0,
      automaticallyImplyLeading: true,
      title: applogo(),
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context)),
      actions: [
        Icon(Icons.notifications_none, color: Colors.white),
        SizedBox(width: 10),
        Icon(Icons.shopping_cart, color: Colors.white),
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
