import 'package:Uthbay/models/grocery_list.dart';
import 'package:Uthbay/models/payment_system.dart';
import 'package:Uthbay/models/stripe_model.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:flutter/material.dart';

enum LoadMoreStatus { INITIAL, LOADING, STABLE }

class GroceryProvider with ChangeNotifier {
  APIService _apiService;

  GroceryList _grocery;
  GroceryList get grocery => _grocery;

  List<GroceryList> _groceryList;
  List<GroceryList> get allGrocery => _groceryList;
  double get totalRecords => _groceryList.length.toDouble();

  PaymentSystem _paymentSystem;
  PaymentSystem get paymentSystem => _paymentSystem;

  StripeAccount _stripeAccount;
  StripeAccount get stripeAccount => _stripeAccount;

  bool _dataNotFound = false;
  bool get dataNotFound => _dataNotFound;

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;
  getLoadMoreStatus() => _loadMoreStatus;

  GroceryProvider() {
    resetStreams();
  }
  setLoadingState(LoadMoreStatus loadMoreStatus) {
    _loadMoreStatus = loadMoreStatus;
    notifyListeners();
  }

  void resetStreams() {
    _apiService = APIService();
    _groceryList = List<GroceryList>();
    _dataNotFound = false;
  }

  setGrocery(GroceryList grocery) {
    _grocery = new GroceryList();
    _grocery = grocery;
  }

  fetchGroceries({int pageNumber, String location, String search}) async {
    print("location ${location}");
    List<GroceryList> itemModel = await _apiService.getGroceriesList(
        location: location, pageNumber: pageNumber, strSerach: search);
    if (itemModel.length > 0) {
      _groceryList.addAll(itemModel);
    } else {
      _dataNotFound = true;
    }
    setLoadingState(LoadMoreStatus.STABLE);
    notifyListeners();
  }

  fetchPaymentSystem(String groceryId) async {
    _paymentSystem = new PaymentSystem();

    _paymentSystem = await _apiService.fetchPaymentSystem(groceryId);

    notifyListeners();
  }

  fetchStripeAccount(String groceryId) async {
    _stripeAccount = new StripeAccount();

    _stripeAccount = await _apiService.fetchStripeAccount(groceryId);
    notifyListeners();
  }
}
