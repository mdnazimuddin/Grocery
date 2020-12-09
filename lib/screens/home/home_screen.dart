import 'package:Uthbay/screens/home/components/body.dart';
import 'package:Uthbay/screens/signin/signin_screen.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  APIService apiService = new APIService();
  test() async {
    apiService.getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Body(),
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
      leading: Container(),
      actions: [
        Icon(Icons.notifications_none, color: Colors.white),
        SizedBox(width: 10),
        // Icon(Icons.shopping_cart, color: Colors.white),
        // SizedBox(width: 10),
        IconButton(
          icon: Icon(Icons.lock, color: Colors.white),
          onPressed: () async {
            apiService.logoutCustomer().then((ret) {
              if (ret) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              }
            });
          },
        )
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
