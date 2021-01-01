import 'package:Uthbay/models/credit_card_model.dart';
import 'package:Uthbay/models/customer_address.dart';
import 'package:Uthbay/models/order.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerProvider with ChangeNotifier {
  APIService _apiService;

  CustomerAddress _customerAddress;
  CustomerAddress get customerAddress => _customerAddress;
  List<Order> _orderList;
  List<Order> get allOrders => _orderList;
  double get totalRecords => _orderList.length.toDouble();

  List<CreditCardModel> _creditCardList;
  List<CreditCardModel> get creditCardModel => _creditCardList;

  CustomerProvider() {
    resetStreams();
  }
  void resetStreams() {
    _apiService = APIService();
  }

  fetchAddress({Function callBack}) async {
    if (_customerAddress == null) {
      _customerAddress = new CustomerAddress();
    }
    await _apiService.getAddress().then((address) => {
          _customerAddress = address,
        });
    print(_customerAddress.address_1);
    notifyListeners();
  }

  getAddress({Function callBack}) async {
    if (_customerAddress == null) {
      _customerAddress = new CustomerAddress();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _status = prefs.getStringList('address') != null ? true : false;

    if (_status) {
      var _address = CustomerAddress().toMap(prefs.getStringList('address'));
      _customerAddress = new CustomerAddress(
        address_1: _address['address_1'],
        address_2: _address['address_2'],
        city: _address['city'],
        state: _address['state'],
        country: _address['country'],
        latitude: _address['latitude'],
        longitude: _address['longitude'],
        zip: _address['zip'],
      );
      callBack(_customerAddress);
      notifyListeners();
    }
  }

  savecreditCard(CreditCardModel model) async {
    await _apiService.savecreditCard(model);
    notifyListeners();
  }

  fetchcreditCard() async {
    if (_creditCardList == null) {
      _creditCardList = new List<CreditCardModel>();
    }
    _creditCardList = await _apiService.fetchcreditCard();
    notifyListeners();
  }

  // fetchOrders() async {
  //   List<Order> orderList = await _apiService.getOrders();

  //   if (_orderList == null) {
  //     _orderList = new List<Order>();
  //   }

  //   if (orderList.length > 0) {
  //     _orderList = [];
  //     _orderList.addAll(orderList);
  //   }

  //   notifyListeners();
  // }
}
