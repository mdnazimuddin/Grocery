import 'package:Uthbay/screens/order/orders_page.dart';
import 'package:Uthbay/screens/shop/components/customer_profile.dart';
import 'package:Uthbay/screens/signin/signin_screen.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';

// make sale return (credit note) for items returned by your customers and keep a track of your inventory
class DrawerPage {
  static Widget drawer(BuildContext context, _scaffoldKey, String firstName,
      String email, String imgUrl) {
    APIService apiService = new APIService();
    print(imgUrl != 'null' || imgUrl != null);
    return Drawer(
      child: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 120,
                color: Colors.redAccent,
              ),
              Positioned(
                left: 30,
                bottom: 50,
                child: Container(
                  width: 50,
                  height: 50,
                  child: CircleAvatar(
                    backgroundColor: Colors.blueAccent.withOpacity(0.02),
                    child: imgUrl != 'null'
                        ? Image.network(imgUrl)
                        : Image.asset('assets/images/boy.png'),
                  ),
                ),
              ),
              Positioned(
                  left: 30,
                  bottom: 25,
                  child: Text("Hi,${firstName}",
                      style: TextStyle(color: Colors.white, fontSize: 16))),
              Positioned(
                  left: 30,
                  bottom: 15,
                  child: Text("${email}",
                      style: TextStyle(color: Colors.white, fontSize: 12)))
            ],
          ),
          SizedBox(height: 30),
          ListTile(
              leading: Icon(Icons.people),
              title: Text('Profile', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CustomerProfile()));
              }),
          ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text('My Orders', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Orderspage()));
              }),
          ListTile(
              leading: Icon(Icons.add_business_sharp),
              title: Text('Favourite Grocery',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CustomerProfile()));
              }),
          ListTile(
              leading: Icon(Icons.edit),
              title:
                  Text('Edit Profile', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CustomerProfile()));
              }),
          ListTile(
              leading: Icon(Icons.notifications),
              title:
                  Text('Notifications', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CustomerProfile()));
              }),
          ListTile(
            leading: Icon(Icons.power_settings_new),
            title: Text('Log Out', style: TextStyle(color: Colors.black)),
            onTap: () async {
              ProgressDialog dialog = new ProgressDialog(context);
              dialog.style(message: 'Please wait...');
              await dialog.show();
              await apiService.logoutCustomer().then((ret) async {
                await dialog.hide();
                if (ret) {
                  final snackBar = SnackBar(
                      content: Text("Logout Successfull"),
                      duration: new Duration(milliseconds: 500));
                  _scaffoldKey.currentState
                      .showSnackBar(snackBar)
                      .closed
                      .then((_) {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: SignInScreen()));
                  });
                }
              });
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.build),
            title: Text('Setting', style: TextStyle(color: Colors.black)),
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => SettingPage()));
            },
          ),
          ExpansionTile(
            leading: Icon(Icons.help_outline),
            title: Text('Help & Support'),
            children: <Widget>[
              Container(
                color: Colors.grey[100],
                height: 100,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        leading: Icon(Icons.call),
                        title: Text('Customer Care'),
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ()));
                        },
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        leading: Icon(Icons.video_collection),
                        title: Text('Tutorials'),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
