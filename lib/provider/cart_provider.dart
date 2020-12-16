import 'package:Uthbay/models/cart_request_model.dart';
import 'package:Uthbay/models/cart_response_model.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  APIService _apiService;
  List<CartItem> _cartItems;

  List<CartItem> get cartItems => _cartItems;
  double get totalRecords => _cartItems.length.toDouble();
  double get totalAmount => _cartItems != null
      ? _cartItems
          .map<double>((e) => e.lineTotal)
          .reduce((value, element) => value + element)
      : 0;
  CartProvider() {
    _apiService = new APIService();
    _cartItems = new List<CartItem>();
  }

  void resetStreams() {
    _apiService = new APIService();
    _cartItems = new List<CartItem>();
  }

  void addToCart(
    int groceryId,
    CartProducts product,
    Function onCallback,
  ) async {
    CartRequestModel requestModel = new CartRequestModel();
    requestModel.products = new List<CartProducts>();
    requestModel.groceryId = groceryId;

    if (_cartItems == null) {
      await fetchCartItems(groceryId);
    }

    _cartItems.forEach((element) {
      requestModel.products.add(new CartProducts(
        productId: element.productId,
        quantity: element.qty,
        variationId: element.variationId,
      ));
    });

    var isProductExist = requestModel.products.firstWhere(
      (prd) =>
          prd.productId == product.productId &&
          prd.variationId == product.variationId,
      orElse: () => null,
    );
    if (isProductExist != null) {
      requestModel.products.remove(isProductExist);
    }

    requestModel.products.add(product);

    await _apiService.addtoCart(requestModel).then((cartResponseModel) {
      if (cartResponseModel.data != null) {
        _cartItems = [];
        _cartItems.addAll(cartResponseModel.data);
      }
      onCallback(cartResponseModel);
      notifyListeners();
    });
  }

  fetchCartItems(int groceryId) async {
    if (_cartItems == null) resetStreams();

    await _apiService.getCartItems(groceryId).then((cartRequestModel) {
      if (cartRequestModel.data != null) {
        _cartItems.addAll(cartRequestModel.data);
      }

      notifyListeners();
    });
  }

  void updateQty(int productId, int qty, {int variationId = 0}) {
    var isProductExist = _cartItems.firstWhere(
        (prd) => prd.productId == productId && prd.variationId == variationId,
        orElse: () => null);
    if (isProductExist != null) {
      isProductExist.qty = qty;
    }

    notifyListeners();
  }

  void updateCart(int groceryId, Function onCallback) async {
    CartRequestModel requestModel = new CartRequestModel();
    requestModel.products = new List<CartProducts>();
    requestModel.groceryId = groceryId;
    if (_cartItems == null) {
      await fetchCartItems(groceryId);
    }

    _cartItems.forEach((element) {
      print("Debug:");
      print(element.productId);
      requestModel.products.add(new CartProducts(
          productId: element.productId,
          quantity: element.qty,
          variationId: element.variationId));
    });

    await _apiService.addtoCart(requestModel).then((cartResponseModel) {
      if (cartResponseModel.data != null) {
        _cartItems = [];
        _cartItems.addAll(cartResponseModel.data);
      }
      onCallback(cartResponseModel);
      notifyListeners();
    });
  }

  void removeItem(int productId,
      {int variationId, int groceryId, Function onCallback}) async {
    var isProductExist = _cartItems.firstWhere(
        (prd) => prd.productId == productId && prd.variationId == variationId,
        orElse: () => null);
    if (isProductExist != null) {
      _cartItems.remove(isProductExist);
    }
    await _apiService
        .removetoCart(
      groceryId: groceryId,
      productId: productId,
      variationId: variationId,
    )
        .then((cartResponseModel) {
      if (cartResponseModel.data != null) {
        _cartItems = [];
        _cartItems.addAll(cartResponseModel.data);
      }
      onCallback(cartResponseModel);
      notifyListeners();
    });
  }
}
