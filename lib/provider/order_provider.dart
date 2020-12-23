import 'package:Uthbay/models/order.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  APIService _apiService;

  List<Order> _orderList;
  List<Order> get allOrders => _orderList;
  double get totalRecords => _orderList.length.toDouble();

  OrderProvider() {
    resetStreams();
  }
  void resetStreams() {
    _apiService = APIService();
  }

  fetchOrders() async {
    List<Order> orderList = await _apiService.getOrders();

    if (_orderList == null) {
      _orderList = new List<Order>();
    }

    if (orderList.length > 0) {
      _orderList = [];
      _orderList.addAll(orderList);
    }

    notifyListeners();
  }
}
