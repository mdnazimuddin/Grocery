import 'package:Uthbay/models/cart_request_model.dart';
import 'package:Uthbay/models/cart_response_model.dart';
import 'package:Uthbay/models/customer_address.dart';
import 'package:Uthbay/models/customer_details.dart';
import 'package:Uthbay/models/customer_details_model.dart';
import 'package:Uthbay/models/order.dart';
import 'package:Uthbay/models/order_tax.dart';
import 'package:Uthbay/models/pickup_model.dart';
import 'package:Uthbay/models/shipping_model.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  APIService _apiService;
  List<CartItem> _cartItems;
  PickupModel _pickupModel;
  CustomerDetails _customerDetailsModel;
  Order _orderModel;
  Shipping _shipping;
  String _shippingPhone;
  String _shippingAddress;
  OrderTax _orderTax;
  bool _isOrderCreated = false;

  List<CartItem> get cartItems => _cartItems;
  double get totalRecords => _cartItems.length.toDouble();
  double get totalAmount => _cartItems != null
      ? _cartItems
          .map<double>((e) => e.lineTotal)
          .reduce((value, element) => value + element)
      : 0;
  PickupModel get pickupModel => _pickupModel;
  CustomerDetails get customerDetailsModel => _customerDetailsModel;
  Order get orderModel => _orderModel;
  Shipping get shipping => _shipping;
  OrderTax get orderTax => _orderTax;
  String get shippingPhone => _shippingPhone;
  String get shippingAddress => _shippingAddress;
  bool get isOrderCreated => _isOrderCreated;

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
        _cartItems = [];
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

  fetchShippingDetails() async {
    if (_customerDetailsModel == null) {
      _customerDetailsModel = new CustomerDetails();
    }

    _customerDetailsModel = await _apiService.customerDetails();
    if (_shipping != null) {
      _customerDetailsModel.shipping = _shipping;
    }
    if (_shippingPhone != null) {
      _customerDetailsModel.phone = _shippingPhone;
    }
    notifyListeners();
  }

  fetchPickup() {
    if (_pickupModel == null) {
      _pickupModel = new PickupModel();
    }

    _pickupModel =
        PickupModel(groceryId: 1, selfPickup: true, onlineOrder: true);
    notifyListeners();
  }

  setShippingAddress(Shipping shipping) {
    if (_shipping == null) {
      _shipping = new Shipping();
    }
    if (_orderModel == null) {
      _orderModel = new Order();
    }
    if (_orderModel.shipping == null) {
      _orderModel.shipping = new Shipping();
    }
    _orderModel.shipping = shipping;
    _shipping = shipping;
    notifyListeners();
  }

  setShippingMobile(String phone) {
    _shippingPhone = phone;
    if (_orderModel == null) {
      _orderModel = new Order();
    }
    if (_orderModel.shipping == null) {
      _orderModel.shipping = new Shipping();
    }
    _orderModel.shipping.phone = phone;
    notifyListeners();
  }

  fetchOrderTax() {
    if (_orderTax == null) {
      _orderTax = new OrderTax();
    }

    _orderTax = OrderTax(
        groceryId: 1, uthbayService: 3.0, productTax: 8.8, delivery: "8.0");
    notifyListeners();
  }

  processOrder(Order orderModel) {
    this._orderModel = orderModel;
    notifyListeners();
  }

  void createOrder() async {
    if (_orderModel.shipping == null) {
      _orderModel.shipping = new Shipping();
    }
    print(_orderModel.delivery);
    // if (this._shipping != null) {
    //   _orderModel.shipping = _shipping;
    // }
    // if (_shippingPhone != null) {
    //   _orderModel.shipping.phone = _shippingPhone;
    // }

    // if (_orderModel.items == null) {
    //   _orderModel.items = new List<CartItem>();
    // }

    // _cartItems.forEach((item) {
    //   _orderModel.items.add(item);
    // });

    // await _apiService.createOrder(orderModel).then((value) {
    //   if (value) {
    //     _isOrderCreated = true;
    //     notifyListeners();
    //   }
    // });
  }
}
