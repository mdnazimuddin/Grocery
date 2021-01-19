import 'package:Uthbay/models/grocery_list.dart';
import 'package:Uthbay/models/payment_system.dart';
import 'package:Uthbay/models/stripe_model.dart';
import 'package:Uthbay/provider/products_provider.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:flutter/material.dart';

// enum LoadMoreStatus { INITIAL, LOADING, STABLE }

class GroceryProvider with ChangeNotifier {
  APIService _apiService;

  GroceryList _grocery;
  GroceryList get grocery => _grocery;

  List<GroceryList> _groceryList;
  List<GroceryList> get allGrocery => _groceryList;
  double get totalRecords => _groceryList.length.toDouble();

  List<GroceryList> _favouriteGroceryList;
  List<GroceryList> get allFavouriteGrocery => _favouriteGroceryList;
  double get totalFavouriteRecords => _favouriteGroceryList.length.toDouble();

  PaymentSystem _paymentSystem;
  PaymentSystem get paymentSystem => _paymentSystem;

  StripeAccount _stripeAccount;
  StripeAccount get stripeAccount => _stripeAccount;

  bool _dataNotFound = false;
  bool get dataNotFound => _dataNotFound;

  bool _favouriteGrocery = false;
  bool get favouriteGrocery => _favouriteGrocery;

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

  fetchFavouriteGrocery() async {
    _apiService = APIService();
    _favouriteGroceryList = List<GroceryList>();
    List<GroceryList> itemModel = await _apiService.fetchFavouriteGrocery();
    if (itemModel.length > 0) {
      _favouriteGroceryList.addAll(itemModel);
    } else {
      _dataNotFound = true;
    }
    setLoadingState(LoadMoreStatus.STABLE);
    notifyListeners();
  }

  favouriteGroceryStatus(String groceryId) async {
    _apiService = APIService();
    _favouriteGrocery = await _apiService.favouriteGroceryStatus(groceryId);
    notifyListeners();
  }

  addFavouriteGrocery(String groceryId) async {
    _apiService = APIService();
    _favouriteGrocery = await _apiService.addFavouriteGrocery(groceryId);
    notifyListeners();
  }

  deleteFavouriteGrocery(String groceryId) async {
    _apiService = APIService();
    _favouriteGrocery = await _apiService.deleteFavouriteGrocery(groceryId);
    notifyListeners();
  }
}
