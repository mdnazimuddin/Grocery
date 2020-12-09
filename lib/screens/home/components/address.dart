import 'dart:ui';

import 'package:Uthbay/models/customer_address.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:Uthbay/utilis/ProgressHUD.dart';
import 'package:Uthbay/utilis/form_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Address extends StatefulWidget {
  bool isUpdate;
  Address({this.isUpdate});
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  APIService apiService;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  CustomerAddress address;
  String address_1;
  String address_2;
  String city;
  String state;
  String zip;
  String country;
  String latitude;
  String longitude;
  bool isLocationStatus = false;
  bool isUpdate = false;
  final Geolocator geolocator = Geolocator();

  Position _currentPosition;
  String _currentAddress;

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      // List<Placemark> p = await geolocator.placemarkFromCoordinates(
      //     _currentPosition.latitude, _currentPosition.longitude);
      List<Placemark> p =
          await geolocator.placemarkFromCoordinates(40.647170, -73.978700);

      Placemark place = p[0];

      setState(() {
        address.address_1 = "${place.name} ${place.thoroughfare}";
        address.address_2 = "";
        address.city = "${place.subLocality}";
        address.state = "${place.administrativeArea}";
        address.zip = "${place.postalCode}";
        address.country = "${place.country}";
        address.latitude = _currentPosition.latitude.toString();
        address.longitude = _currentPosition.longitude.toString();

        isLocationStatus = true;
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  getResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _status = prefs.getStringList('address') != null ? true : false;
    print(_status);
    if (_status) {
      var _address = CustomerAddress().toMap(prefs.getStringList('address'));
      setState(() {
        address = CustomerAddress(
          address_1: _address['address_1'],
          address_2: _address['address_2'] ?? '',
          city: _address['city'],
          state: _address['state'],
          zip: _address['zip'],
          country: _address['country'],
          latitude: _address['latitude'] ?? '',
          longitude: _address['longitude'] ?? '',
        );
        this.isLocationStatus = true;
      });
    } else {
      address = new CustomerAddress();
    }
  }

  _onLayoutDone(_) {
    getResult();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    super.initState();
    apiService = new APIService();
    this.isUpdate = widget.isUpdate ?? false;
    print(isUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.isUpdate ? "Change Address" : "New Address"),
        elevation: 5,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context, false)),
        actions: [
          this.isUpdate
              ? IconButton(
                  icon: Icon(Icons.gps_fixed_sharp,
                      color: Theme.of(context).accentColor),
                  onPressed: () => _getCurrentLocation())
              : SizedBox()
        ],
      ),
      body: ProgressHUD(
        child: _uipage(context),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
      ),
    );
  }

  Widget _uipage(BuildContext context) {
    return SingleChildScrollView(
      child:
          isLocationStatus ? beforeLocation(context) : afterLocation(context),
    );
  }

  Widget afterLocation(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      child: InkWell(
        onTap: () => _getCurrentLocation(),
        child: Container(
          child: ListTile(
            leading: Icon(Icons.gps_fixed_sharp,
                color: Theme.of(context).accentColor),
            title: Text('Use current location'),
            subtitle: Text('Uthbayshop needs asccess to your location'),
            trailing: Icon(Icons.keyboard_arrow_right_rounded),
          ),
        ),
      ),
    );
  }

  Widget beforeLocation(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Form(
        key: globalKey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              onSaved: (input) => address.address_1 = input,
              initialValue: address.address_1,
              validator: (input) =>
                  input.length <= 0 ? "Enter Valid Address." : null,
              decoration: InputDecoration(
                hintText: "Enter an address",
                labelText: "Address",
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor.withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                prefixIcon: Icon(Icons.location_on,
                    color: Theme.of(context).accentColor),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              onSaved: (input) => address.city = input,
              initialValue: address.city,
              validator: (input) =>
                  input.length <= 0 ? "Enter Valid City." : null,
              decoration: InputDecoration(
                hintText: "Enter a city",
                labelText: "City",
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor.withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                prefixIcon: Icon(Icons.location_on,
                    color: Theme.of(context).accentColor),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              onSaved: (input) => address.state = input,
              initialValue: address.state,
              validator: (input) =>
                  input.length <= 0 ? "Enter Valid State." : null,
              decoration: InputDecoration(
                hintText: "Enter State",
                labelText: "State",
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor.withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                prefixIcon: Icon(Icons.location_on,
                    color: Theme.of(context).accentColor),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              onSaved: (input) => address.zip = input,
              initialValue: address.zip,
              validator: (input) =>
                  input.length <= 0 ? "Enter Valid Postal Code." : null,
              decoration: InputDecoration(
                hintText: "Enter a Postal Code",
                labelText: "Postal Code",
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor.withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                prefixIcon: Icon(Icons.location_on,
                    color: Theme.of(context).accentColor),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              enabled: false,
              onSaved: (input) => address.country = input,
              initialValue: address.country,
              validator: (input) =>
                  input.length <= 0 ? "Enter Valid Country." : null,
              decoration: InputDecoration(
                hintText: "Enter a country",
                labelText: "Country",
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor.withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                prefixIcon: Icon(Icons.location_on,
                    color: Theme.of(context).accentColor),
              ),
            ),
            SizedBox(height: 30),
            FlatButton(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
              onPressed: () {
                if (validetAndSave()) {
                  setState(() {
                    isApiCallProcess = true;
                  });
                  print(address.address_1);
                  apiService.createAddress(address).then((ret) {
                    if (ret) {
                      Navigator.pop(context, true);
                    } else {
                      setState(() {
                        FormHelper.showMessage(
                          context,
                          "Uthbay Grocery",
                          "Address Save Faild! Please try again.",
                          "OK",
                          () {
                            Navigator.of(context).pop();
                          },
                        );
                      });
                    }
                  });
                }
              },
              child: Text(
                this.isUpdate ? 'Update' : "Save",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).accentColor,
              shape: StadiumBorder(),
            )
          ],
        ),
      ),
    );
  }

  bool validetAndSave() {
    final form = globalKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
