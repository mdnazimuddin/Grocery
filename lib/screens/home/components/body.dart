import 'dart:async';

import 'package:Uthbay/models/customer_address.dart';
import 'package:Uthbay/models/grocery_list.dart';
import 'package:Uthbay/provider/grocery_provider.dart';
import 'package:Uthbay/screens/shop/shop_screen.dart';
import 'package:Uthbay/screens/widgets/DrawerPage.dart';
import 'package:Uthbay/screens/widgets/build_app_bar.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'address.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var locationController = new TextEditingController();
  int _page = 1;
  ScrollController _scrollController = new ScrollController();
  final _searchQuery = new TextEditingController();
  String address;
  Map<String, dynamic> _addressMap;
  bool addressStatus = false;
  APIService apiService;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String firstName;
  String email;
  String imgUrl;

  getResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _firstName = prefs.getString('first_name');
    String _email = prefs.getString('email');
    String _imgUrl = prefs.getString('img_src');
    bool _status = prefs.getStringList('address') != null ? true : false;
    if (_status) {
      var _address = CustomerAddress().toMap(prefs.getStringList('address'));
      setState(() {
        this.address =
            "${_address['address_1']}, ${_address['city']}, ${_address['state']}";
        this.addressStatus = true;
        this._addressMap = _address;
        firstName = _firstName;
        email = _email;
        imgUrl = _imgUrl;
      });
      print(_address['zip'].toString());
      var groceriesList = Provider.of<GroceryProvider>(context, listen: false);
      groceriesList.resetStreams();
      groceriesList.setLoadingState(LoadMoreStatus.INITIAL);
      groceriesList.fetchGroceries(location: _address['zip'].toString());
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          groceriesList.setLoadingState(LoadMoreStatus.LOADING);

          groceriesList.fetchGroceries(
              pageNumber: ++_page, location: _address['zip'].toString());
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    getResult();
    // WidgetsBinding.instance.addPostFrameCallback((_) {

    // });
  }

  _onSearchChang(String searchValue) {
    var groceriesList = Provider.of<GroceryProvider>(context, listen: false);
    groceriesList.resetStreams();
    groceriesList.setLoadingState(LoadMoreStatus.INITIAL);
    groceriesList.fetchGroceries(
        location: _addressMap['zip'].toString(), search: searchValue);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer:
          DrawerPage.drawer(context, _scaffoldKey, firstName, email, imgUrl),
      appBar: buildAppBar(context),
      body: addressStatus ? _uipage(context) : _initpage(context),
    );
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
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: Address()));
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

  Widget _groceriesList() {
    return new Consumer<GroceryProvider>(
      builder: (BuildContext context, grocery, child) {
        Timer(const Duration(microseconds: 10), () {
          return _returnText();
        });
        if (grocery.allGrocery != null &&
            grocery.allGrocery.length > 0 &&
            grocery.getLoadMoreStatus() != LoadMoreStatus.INITIAL)
          return _buildGroceryList(
            grocery.allGrocery,
            grocery.getLoadMoreStatus() == LoadMoreStatus.LOADING,
          );
        else if (grocery.dataNotFound) {
          return _returnText();
        } else {
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.amber),
          ));
        }
      },
    );
  }

  Widget _returnText() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Data Not Found"),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                var groceriesList =
                    Provider.of<GroceryProvider>(context, listen: false);
                groceriesList.resetStreams();
                groceriesList.setLoadingState(LoadMoreStatus.INITIAL);
                groceriesList.fetchGroceries(
                    location: _addressMap['zip'].toString());
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGroceryList(List<GroceryList> groceries, bool isLoadMore) {
    return ListView.builder(
        controller: _scrollController,
        itemCount: groceries.length ?? 0,
        itemBuilder: (context, index) {
          GroceryList grocery = groceries[index];
          return customCard(grocery);
        });
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
                controller: _searchQuery,
                onSubmitted: (value) {
                  this._onSearchChang(value);
                },
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
                  hintStyle: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.normal,
                      fontSize: 14),
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
        // Expanded(
        //   flex: 10,
        //   child: FutureBuilder<Object>(
        //       future: apiService.getGroceriesList(),
        //       builder: (context, snapshot) {
        //         if (!snapshot.hasData)
        //           return Center(
        //               child: CircularProgressIndicator(
        //             valueColor: AlwaysStoppedAnimation(Colors.amber),
        //           ));
        //         else {
        //           print(snapshot.data);
        //           List<GroceryList> groceries = snapshot.data;
        //           return ListView.builder(
        //               itemCount: groceries.length ?? 0,
        //               itemBuilder: (context, index) {
        //                 GroceryList grocery = groceries[index];
        //                 return customCard(grocery);
        //               });
        //         }
        //       }),
        // ),
        Expanded(
          flex: 10,
          child: _groceriesList(),
        ),
      ],
    );
  }

  Widget customCard(GroceryList grocery) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 25,
      ),
      child: InkWell(
        onTap: () async {
          Provider.of<GroceryProvider>(context, listen: false)
              .setGrocery(grocery);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShopScreen(
                        grocery: grocery,
                      )));
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
                            fit: BoxFit.cover,
                            image: NetworkImage(grocery.cover_img)),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0)),
                        color: Colors.redAccent,
                      ),
                    ),
                    Visibility(
                      visible: int.parse(grocery.rating) > 0,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 5),
                              color: Colors.redAccent,
                              child: Row(
                                children: [
                                  Text(
                                    grocery.rating,
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
                      ),
                    ),
                  ],
                ),
                Container(
                  // padding: EdgeInsets.only(left: 20, bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(grocery.logo),
                        radius: 25.0),
                    title: Row(
                      children: [
                        Text(
                          grocery.name,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      "${grocery.address.address_1}, ${grocery.address.city}, ${grocery.address.state}",
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                    trailing: Text(
                      grocery.opening_status ? 'Opened' : 'Closed',
                      style: TextStyle(
                        color:
                            grocery.opening_status ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
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
