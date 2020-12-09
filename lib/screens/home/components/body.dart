import 'dart:async';

import 'package:Uthbay/models/customer_address.dart';
import 'package:Uthbay/models/grocery_list.dart';
import 'package:Uthbay/screens/shop/shop_screen.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:Uthbay/utilis/ProgressHUD.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'address.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var locationController = new TextEditingController();
  String address;
  bool addressStatus = false;
  APIService apiService;
  List<GroceryList> groceriesList = new List<GroceryList>();

  getResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _status = prefs.getStringList('address') != null ? true : false;
    print(_status);
    if (_status) {
      var _address = CustomerAddress().toMap(prefs.getStringList('address'));
      setState(() {
        this.address =
            "${_address['address_1']}, ${_address['city']}, ${_address['state']}";
        this.addressStatus = true;
      });
      print(address);
    }
  }

  getGrocery() async {
    apiService.getGroceriesList().then((data) => {groceriesList = data});
  }

  _onLayoutDone(_) {
    getResult();
    getGrocery();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    super.initState();
    apiService = new APIService();
  }

  List<String> langnames = [
    'Halal Grocery Shop',
    'Freash Grocery Shop',
    'US Bangla Grocery Shop',
    'BD Food Grocery',
    'Healthy Food'
  ];
  List<String> images = [
    "https://images.wsj.net/im-57265?width=1280&size=1.77777778",
    "https://thumbs.dreamstime.com/b/hygienic-smiling-asian-delivery-man-carrying-grocery-tray-box-supermarket-banner-background-179268522.jpg",
    "https://st2.depositphotos.com/7341970/11081/v/950/depositphotos_110819808-stock-illustration-grocery-shopping-discount-banner.jpg",
    "https://st2.depositphotos.com/7341970/11081/v/950/depositphotos_110819808-stock-illustration-grocery-shopping-discount-banner.jpg",
    "https://thumbs.dreamstime.com/b/hygienic-smiling-asian-delivery-man-carrying-grocery-tray-box-supermarket-banner-background-179268522.jpg",
  ];

  List<String> des = [
    "Grocery",
    "Grocery",
    "Grocery",
    "Grocery",
    "Grocery",
  ];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return addressStatus ? _uipage(context) : _initpage(context);
  }

  Widget _initpage(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 7,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Text(
                    'Explore nearby stores',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Text(
                    'To begin add an address where you want to receive your orders.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black45, fontSize: 16),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Center(
                    child: FlatButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                      onPressed: () async {
                        bool status = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Address()));
                        WidgetsBinding.instance
                            .addPostFrameCallback(_onLayoutDone);
                        setState(() {
                          this.addressStatus = status;
                        });
                      },
                      child: Text(
                        "Enter address",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Theme.of(context).accentColor,
                      shape: StadiumBorder(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _uipage(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.white70,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time,
                              color: Theme.of(context).accentColor, size: 20),
                          SizedBox(width: 2),
                          Text('Now',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  VerticalDivider(),
                  Expanded(
                    flex: 10,
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Address(
                                    isUpdate: true,
                                  ))),
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.location_pin,
                                color: Theme.of(context).accentColor),
                            Flexible(
                              child: Text(
                                '${address ?? 'Address'}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding:
                      new EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent, //this has no effect
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  hintText: "Search Near Grocery ...",
                  prefixIcon: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 5.0),
                    child: Icon(
                      Icons.search,
                      color: Theme.of(context).accentColor,
                    ), // Change this icon as per your requirement
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(),
        // Expanded(
        //   flex: 1,
        //   child: Padding(
        //     // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        //     padding: EdgeInsets.all(2),
        //     child: Text(
        //       'Near by  Grocery',
        //       textAlign: TextAlign.left,
        //       style: TextStyle(
        //           color: Colors.black45,
        //           fontWeight: FontWeight.bold,
        //           fontSize: 15),
        //     ),
        //   ),
        // ),
        Expanded(
          flex: 10,
          child: FutureBuilder<Object>(
              future: apiService.getGroceriesList(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.amber),
                  ));
                else {
                  print(snapshot.data);
                  return ListView.builder(
                      itemCount: groceriesList.length ?? 0,
                      itemBuilder: (context, index) {
                        return customCard(
                          groceriesList[index].name,
                          groceriesList[index].logo,
                          groceriesList[index].cover_img,
                          groceriesList[index].opening_status,
                          groceriesList[index].address,
                          groceriesList[index].rating,
                          groceriesList[index].href,
                        );
                      });
                }
              }),
        ),
      ],
    );
  }

  Widget customCard(String name, String logo, String image, bool isOpen,
      GroceryAddress address, String rating, Href href) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 25,
      ),
      child: InkWell(
        onTap: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ShopScreen(href.link)));
        },
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          elevation: 5,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: 180.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover, image: NetworkImage(image)),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0)),
                        color: Colors.redAccent,
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 5),
                            color: Colors.red,
                            child: Row(
                              children: [
                                Text(
                                  rating,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  // padding: EdgeInsets.only(left: 20, bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(logo), radius: 25.0),
                    title: Text(
                      name,
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      "${address.address_1}, ${address.city}, ${address.state}",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    trailing: Text(
                      isOpen ? 'Open' : 'Close',
                      style: TextStyle(
                        color: isOpen ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
