import 'package:Uthbay/models/cart_request_model.dart';
import 'package:Uthbay/models/cart_response_model.dart';
import 'package:Uthbay/models/credit_card_model.dart';
import 'package:Uthbay/models/customer.dart';
import 'package:Uthbay/models/customer_address.dart';
import 'package:Uthbay/models/customer_details.dart';
import 'package:Uthbay/models/customer_details_model.dart';
import 'package:Uthbay/models/grocery.dart';
import 'package:Uthbay/models/grocery_list.dart';
import 'package:Uthbay/models/login_model.dart';
import 'package:Uthbay/models/order.dart';
import 'package:Uthbay/models/order_model.dart';
import 'package:Uthbay/models/order_tax.dart';
import 'package:Uthbay/models/payment_system.dart';
import 'package:Uthbay/models/pickup_model.dart';
import 'package:Uthbay/models/product.dart';
import 'package:Uthbay/models/stripe_model.dart';
import 'package:Uthbay/models/tag.dart';
import 'package:Uthbay/models/variable_product.dart';
import 'package:Uthbay/utilis/config.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  Future<bool> createCustomer({CustomerModel model}) async {
    bool ret = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var response = await Dio().post(
        Config.customerURL + 'register',
        options: new Options(headers: {'Accept': 'application/json'}),
        data: model.toJson(),
      );
      if (response.statusCode == 200) {
        ret = true;
        var token = "Bearer " + response.data['success']['token'].toString();
        print(token);
        prefs.setString('token', token);
        prefs.setString('id', response.data['success']['id'].toString());
        prefs.setString(
            'first_name', response.data['success']['first_name'].toString());
        prefs.setString(
            'last_name', response.data['success']['last_name'].toString());
        prefs.setString('email', response.data['success']['email'].toString());
        prefs.setString(
            'img_src', response.data['success']['img_src'].toString());
        prefs.setBool('login', true);
        prefs.setBool('install', true);
      }
    } on DioError catch (e) {
      print(e);
      if (e.response.statusCode == 404) {
        ret = false;
      } else {
        ret = false;
      }
    }
    return ret;
  }

  Future<bool> loginCustomer(String email, String password) async {
    LoginResponseModel model;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool ret = false;
    try {
      var response = await Dio().post(
        Config.customerURL + 'login',
        options: new Options(headers: {
          'Accept': 'application/json',
        }),
        data: {
          "email": email,
          "password": password,
        },
      );
      if (response.statusCode == 200) {
        ret = true;
        var token = "Bearer " + response.data['success']['token'].toString();
        print(token);
        prefs.setString('token', token);
        prefs.setString('id', response.data['success']['id'].toString());
        prefs.setString(
            'first_name', response.data['success']['first_name'].toString());
        prefs.setString(
            'last_name', response.data['success']['last_name'].toString());
        prefs.setString('email', response.data['success']['email'].toString());
        prefs.setString(
            'img_src', response.data['success']['img_src'].toString());
        prefs.setBool('login', true);
        prefs.setBool('install', true);
      }
    } on DioError catch (e) {
      print(e.message);
      if (e.response.statusCode == 404) {
        ret = false;
      } else {
        ret = false;
      }
    }
    await getAddress();
    return ret;
  }

  Future<bool> logoutCustomer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    bool ret = false;
    try {
      print(Config.customerURL + 'logout');
      var response = await Dio().post(
        Config.customerURL + 'logout',
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        ret = true;
        prefs.setString('token', null);
        prefs.setString('id', null);
        prefs.setString('first_name', null);
        prefs.setString('last_name', null);
        prefs.setString('email', null);
        prefs.setString('img_src', null);
        prefs.setStringList('address', null);
        prefs.setBool('login', false);
      }
    } on DioError catch (e) {
      print(e.message);
      if (e.response.statusCode == 404) {
        ret = false;
      } else {
        ret = false;
      }
    }

    return ret;
  }

  Future<bool> updateProfile(CustomerModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool ret = false;
    try {
      print(Config.customerURL + Config.updateProfileURL);
      print(model.toJson());
      var response = await Dio().post(
        Config.customerURL + Config.updateProfileURL,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
        data: model.toJson(),
      );
      print(response.data['data']['img_src']);
      if (response.statusCode == 200) {
        prefs.setString('first_name', response.data['data']['first_name']);
        prefs.setString('last_name', response.data['data']['last_name']);
        prefs.setString('email', response.data['data']['email']);
        prefs.setString('phone', response.data['data']['phone']);
        prefs.setString('img_src', response.data['data']['img_src']);
        ret = true;
      }
    } on DioError catch (e) {
      print(e.message);
      ret = false;
    }

    return ret;
  }

  Future<bool> createAddress(CustomerAddress address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool ret = false;
    try {
      print(Config.customerURL + 'storeAddress');
      var response = await Dio().post(
        Config.customerURL + 'storeAddress',
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
        data: address.toJson(),
      );
      print(response.data);
      if (response.statusCode == 200) {
        List<String> address = [
          response.data['data']['address_1'],
          response.data['data']['address_2'],
          response.data['data']['city'],
          response.data['data']['state'],
          response.data['data']['zip'],
          response.data['data']['country'],
          response.data['data']['latitude'],
          response.data['data']['longitude']
        ];
        print(address);

        prefs.setStringList('address', address);
        ret = true;
      }
    } on DioError catch (e) {
      print(e.message);
      ret = false;
    }

    return ret;
  }

  Future<CustomerAddress> updateAddress(CustomerAddress address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CustomerAddress customerAddress = new CustomerAddress();
    try {
      var response = await Dio().post(
        Config.customerURL + 'address',
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
      );
      if (response.statusCode == 200) {
        List<String> address = [
          response.data['data']['address_1'],
          response.data['data']['address_2'],
          response.data['data']['city'],
          response.data['data']['state'],
          response.data['data']['zip'],
          response.data['data']['country'],
          response.data['data']['latitude'],
          response.data['data']['longitude']
        ];
        print(address);

        prefs.setStringList('address', address);
        var cust = CustomerAddress().toMap(address);

        print(cust['city']);
      }
    } on DioError catch (e) {
      print(e.message);
    }
    print("Call Address func");
    return customerAddress;
  }

  Future<CustomerAddress> getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CustomerAddress customerAddress = new CustomerAddress();
    try {
      var response = await Dio().post(
        Config.customerURL + 'address',
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
      );
      if (response.statusCode == 200) {
        List<String> address = [
          response.data['data']['address_1'],
          response.data['data']['address_2'],
          response.data['data']['city'],
          response.data['data']['state'],
          response.data['data']['zip'],
          response.data['data']['country'],
          response.data['data']['latitude'],
          response.data['data']['longitude']
        ];
        print(address);

        prefs.setStringList('address', address);
        var cust = CustomerAddress().toMap(address);

        print(cust['state']);
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return customerAddress;
  }

  Future<List<GroceryList>> getGroceriesList(
      {String location, int pageNumber, String strSerach}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<GroceryList> groceriesList = new List<GroceryList>();

    try {
      String parameter = "";
      if (location != null) {
        parameter += "&location=${location.toString()}";
      }
      if (strSerach != null) {
        parameter += "&search=${strSerach.toString()}";
      }
      if (pageNumber != null) {
        parameter += "&page=${pageNumber.toString()}";
      }
      var groceriesURL = Config.groceryListURL + parameter.toString();
      print(groceriesURL);
      var response = await Dio().get(groceriesURL);
      print(response.data.isNotEmpty);
      if (response.statusCode == 200 && response.data.isNotEmpty) {
        for (var item in response.data['data']) {
          GroceryList _groceries = GroceryList.fromJson(item);
          groceriesList.add(_groceries);
        }
      } else {
        return [];
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return groceriesList;
  }

  Future<Grocery> getGrocery(String url) async {
    Grocery grocery = new Grocery();
    // print('Url: $url');
    try {
      var response = await Dio().get(url);
      // print(response.data);
      if (response.statusCode == 200) {
        grocery = Grocery.fromJson(response.data['data']);
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return grocery;
  }

  Future<List<SliderImages>> getGroceryImages(String url) async {
    List<SliderImages> images = new List<SliderImages>();

    var imgUrl = url + '/images';

    try {
      var response = await Dio().get(imgUrl);
      if (response.statusCode == 200) {
        for (var item in response.data['data']) {
          SliderImages _img = SliderImages.fromJson(item);
          images.add(_img);
        }
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return images;
  }

  Future<List<Category>> getGroceryCategories(String url) async {
    List<Category> categories = new List<Category>();

    var categoryUrl = url + '/categories';

    try {
      var response = await Dio().get(categoryUrl);
      if (response.statusCode == 200) {
        for (var item in response.data['data']) {
          Category _category = Category.fromJson(item);
          categories.add(_category);
        }
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return categories;
  }

  Future<bool> fetchFavouriteGrocerys(String groceryId) async {
    bool status = false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var url = Config.customerURL + '/addFavouriteGrocery';
      Map<String, dynamic> data = {'grocery_id': groceryId};
      var response = await Dio().post(
        url,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
        data: data,
      );
      print(response.data['status']);
      if (response.statusCode == 200) {
        status = response.data['status'];
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return status;
  }

  Future<List<GroceryList>> fetchFavouriteGrocery() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<GroceryList> groceriesList = new List<GroceryList>();

    try {
      String parameter = "favouriteGroceries";

      var groceriesURL = Config.customerURL + parameter.toString();
      print(groceriesURL);
      var response = await Dio().post(
        groceriesURL,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
      );
      if (response.statusCode == 200 && response.data.isNotEmpty) {
        for (var item in response.data['data']) {
          GroceryList _groceries = GroceryList.fromJson(item);
          groceriesList.add(_groceries);
        }
      } else {
        return [];
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return groceriesList;
  }

  Future<bool> favouriteGroceryStatus(String groceryId) async {
    bool status = false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var url = Config.customerURL + 'favouriteGroceryStatus';
      Map<String, dynamic> data = {'grocery_id': groceryId};
      print(url);
      var response = await Dio().post(
        url,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
        data: data,
      );
      print(response.data['status']);
      if (response.statusCode == 200) {
        status = response.data['status'];
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return status;
  }

  Future<bool> addFavouriteGrocery(String groceryId) async {
    bool status = false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var url = Config.customerURL + 'addFavouriteGrocery';
      Map<String, dynamic> data = {'grocery_id': groceryId};
      var response = await Dio().post(
        url,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
        data: data,
      );
      if (response.statusCode == 200) {
        status = true;
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return status;
  }

  Future<bool> deleteFavouriteGrocery(String groceryId) async {
    bool status = false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var url = Config.customerURL + 'deleteFavouriteGrocery';
      Map<String, dynamic> data = {'grocery_id': groceryId};
      var response = await Dio().post(
        url,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
        data: data,
      );
      if (response.statusCode == 200) {
        status = false;
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return status;
  }

  Future<List> getTags(String url) async {
    List tags = new List();

    var tagUrl = url + '/tags';

    try {
      var response = await Dio().get(tagUrl);

      if (response.statusCode == 200) {
        for (var item in response.data['data']) {
          print(item['des']);
          Map<String, dynamic> _tag = {
            'id': item['id'],
            'name': item['name'],
            'slug': item['slug'],
            'des': item['des']
          };
          print(_tag);
          tags.add(_tag);
        }
      }
    } on DioError catch (e) {
      print(e.message);
    }
    print(tags);
    return tags;
  }

  Future<List<Product>> getProducts({
    dynamic pageNumber,
    dynamic pageSize,
    dynamic strSerach,
    dynamic groceryId,
    dynamic tagId,
    dynamic categoryId,
    List<int> productIds,
    dynamic sortBy,
    dynamic sortOrder,
  }) async {
    List<Product> products = new List<Product>();

    try {
      String parameter = "";
      if (strSerach != null) {
        parameter += "&search=$strSerach";
      }
      if (pageSize != null) {
        parameter += "&pageSize=$pageSize";
      }
      if (pageNumber != null) {
        parameter += "&page=${pageNumber.toString()}";
      }
      if (groceryId != null) {
        parameter += "&grocery=$groceryId";
      }
      if (tagId != null) {
        parameter += "&tag=$tagId";
      }
      if (categoryId != null) {
        parameter += "&category=$categoryId";
      }
      if (productIds != null) {
        parameter += "&include=${productIds.join(",").toString()}";
      }
      if (sortBy != null) {
        parameter += "&sortBy=$sortBy";
      }
      if (sortOrder != null) {
        parameter += "&order=$sortOrder";
      }
      var productUrl = Config.productURL + parameter.toString();
      print(productUrl);
      var response = await Dio().get(productUrl);
      print(response.data['data']);
      if (response.statusCode == 200) {
        for (dynamic item in response.data['data']) {
          Product _product = Product.fromJson(item);
          products.add(_product);
        }
      }
      print(response.data['data']);
    } on DioError catch (e) {
      print(e.message);
    }
    return products;
  }

  Future<List<VariableProduct>> getVariableProducts({dynamic productId}) async {
    List<VariableProduct> responseModel = new List<VariableProduct>();

    try {
      String parameter =
          Config.variableProductsURL + "/" + productId.toString();

      var url = Config.productURL + parameter;
      print(url);
      var response = await Dio().get(parameter);
      print(response.data['data']);
      if (response.statusCode == 200) {
        for (dynamic item in response.data['data']) {
          VariableProduct _responseModel = VariableProduct.fromJson(item);
          responseModel.add(_responseModel);
        }
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return responseModel;
  }

  Future<List<Product>> fetchFavouriteGroceryProduct(String groceryId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Product> products = new List<Product>();

    try {
      String parameter = "favouriteGroceryProducts";

      var productURL = Config.customerURL + parameter.toString();
      print(productURL);
      Map<String, dynamic> data = {'grocery_id': groceryId};
      var response = await Dio().post(
        productURL,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
        data: data,
      );
      print(response.data);
      if (response.statusCode == 200 && response.data.isNotEmpty) {
        if (response.statusCode == 200) {
          for (dynamic item in response.data['data']) {
            Product _product = Product.fromJson(item);
            products.add(_product);
          }
        }
      } else {
        return [];
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return products;
  }

  Future<bool> favouriteGroceryProductStatus(
      String groceryId, String productId) async {
    bool status = false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var url = Config.customerURL + 'favouriteProductStatus';
      Map<String, dynamic> data = {
        'grocery_id': groceryId,
        'product_id': productId
      };
      print(url);
      var response = await Dio().post(
        url,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
        data: data,
      );
      print(response.data['status']);
      if (response.statusCode == 200) {
        status = response.data['status'];
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return status;
  }

  Future<bool> addFavouriteGroceryProduct(
      String groceryId, String productId) async {
    bool status = false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var url = Config.customerURL + 'addFavouriteGroceryProduct';
      Map<String, dynamic> data = {
        'grocery_id': groceryId,
        'product_id': productId
      };
      var response = await Dio().post(
        url,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
        data: data,
      );
      if (response.statusCode == 200) {
        status = true;
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return status;
  }

  Future<bool> deleteFavouriteGroceryProduct(
      String groceryId, String productId) async {
    bool status = false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var url = Config.customerURL + 'deleteFavouriteGroceryProduct';
      Map<String, dynamic> data = {
        'grocery_id': groceryId,
        'product_id': productId
      };
      var response = await Dio().post(
        url,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
        data: data,
      );
      if (response.statusCode == 200) {
        status = false;
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return status;
  }

  Future<CartResponseModel> addtoCart(CartRequestModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CartResponseModel responseModel;
    try {
      print(Config.customerURL + Config.addtoCartURL);
      model.userId = int.parse(prefs.getString('id'));
      print(model.toJson());
      var response = await Dio().post(
        Config.customerURL + Config.addtoCartURL,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
        data: model.toJson(),
      );
      print("Res: ${response.data}");
      if (response.statusCode == 200) {
        responseModel = CartResponseModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.message);
    }

    print(responseModel.data);
    return responseModel;
  }

  Future<CartResponseModel> updateToCartQty(
      {int groceryId, int productId, int variationId, int qty}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CartResponseModel responseModel;
    try {
      print(Config.customerURL + Config.addtoCartURL);
      Map<String, dynamic> data = {
        'grocery_id': groceryId,
        'product_id': productId,
        'variation_id': variationId,
        'quantity': qty,
        'customer_id': prefs.getString('id')
      };
      var response = await Dio().post(
        Config.customerURL + Config.addtoCartURL,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
        data: data,
      );
      print("Res: ${response.data}");
      if (response.statusCode == 200) {
        responseModel = CartResponseModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.message);
    }

    print(responseModel.data);
    return responseModel;
  }

  Future<CartResponseModel> removetoCart({
    int groceryId,
    int productId,
    int variationId,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CartResponseModel responseModel;
    try {
      print(Config.customerURL + Config.addtoCartURL);
      Map<String, dynamic> data = {
        'grocery_id': groceryId,
        'product_id': productId,
        'variation_id': variationId,
        'customer_id': prefs.getString('id')
      };
      print(Config.customerURL + Config.removeCartURL);
      print(data);
      var response = await Dio().post(
        Config.customerURL + Config.removeCartURL,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
        data: data,
      );
      print("Remove: ${response.data}");
      if (response.statusCode == 200) {
        responseModel = CartResponseModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.message);
    }

    // print(responseModel.data[0].productId);
    return responseModel;
  }

  Future<CartResponseModel> getCartItems(int groceryId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CartResponseModel responseModel;
    print(groceryId);
    try {
      var url = Config.customerURL + Config.cartURL;
      Map<String, dynamic> data = {
        'grocery_id': groceryId,
        'customer_id': prefs.getString('id')
      };
      print(data);
      print(Config.customerURL + Config.cartURL);
      var response = await Dio().post(
        Config.customerURL + Config.cartURL,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
        data: data,
      );
      print(response.data);
      if (response.statusCode == 200 && response.data != null) {
        responseModel = CartResponseModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return responseModel;
  }

  Future<CustomerDetails> customerDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CustomerDetails responseModel;
    try {
      var url = Config.customerURL + Config.detailsURL;

      print(url);
      var response = await Dio().post(
        url,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
      );
      print(response.data['data']);
      if (response.statusCode == 200) {
        responseModel = CustomerDetails.fromJson(response.data['data']);
      }
    } on DioError catch (e) {
      print(e.message);
    }
    print(responseModel.shipping.address1);

    return responseModel;
  }

  Future<PickupModel> fetchPickup(String groceryId) async {
    PickupModel responseModel;
    try {
      var url = Config.url + groceryId + '/' + Config.pickupURL;

      print(url);
      var response = await Dio().get(url);
      print("Call");
      print(response.data);
      if (response.statusCode == 200) {
        responseModel = PickupModel.fromJson(response.data['data']);
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return responseModel;
  }

  Future<OrderTax> fetchOrderTax(String groceryId) async {
    OrderTax responseModel;
    try {
      var url = Config.url + groceryId + '/' + Config.orderTaxURL;

      print(url);
      var response = await Dio().get(url);
      // print("Call");
      print(response.data);
      if (response.statusCode == 200) {
        responseModel = OrderTax.fromJson(response.data['data']);
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return responseModel;
  }

  Future<PaymentSystem> fetchPaymentSystem(String groceryId) async {
    PaymentSystem responseModel;
    try {
      var url = Config.url + groceryId + '/' + Config.paymentSystem;

      print(url);
      var response = await Dio().get(url);
      print("Call");
      print(response.data);
      if (response.statusCode == 200) {
        responseModel = PaymentSystem.fromJson(response.data['data']);
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return responseModel;
  }

  Future<StripeAccount> fetchStripeAccount(String groceryId) async {
    StripeAccount responseModel;
    try {
      var url = Config.url + groceryId + '/' + Config.stripeURL;

      print(url);
      var response = await Dio().get(url);
      print("Call");
      print(response.data);
      if (response.statusCode == 200) {
        responseModel = StripeAccount.fromJson(response.data['data']);
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return responseModel;
  }

  Future<bool> savecreditCard(CreditCardModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isOrderCreated;
    print(model.toJson());
    try {
      var url = Config.customerURL + Config.saveCardURL;
      print(url);
      var response = await Dio().post(
        url,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
        data: model.toJson(),
      );
      print(response.data);
      if (response.statusCode == 200) {
        isOrderCreated = true;
      }
    } on DioError catch (e) {
      print(e.message);
      isOrderCreated = false;
    }

    return isOrderCreated;
  }

  Future<List<CreditCardModel>> fetchcreditCard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<CreditCardModel> creditCards = new List<CreditCardModel>();

    try {
      var url = Config.customerURL + Config.getCardURL;
      print(url);
      var response = await Dio().post(
        url,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
      );
      print(response.data);
      if (response.statusCode == 200) {
        for (dynamic item in response.data['data']) {
          CreditCardModel _card = CreditCardModel.fromJson(item);
          creditCards.add(_card);
        }
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return creditCards;
  }

  Future<bool> createOrder(Order model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isOrderCreated = false;
    print(model.toJson());
    try {
      var url = Config.customerURL + Config.createOrderURL;
      print(url);
      var response = await Dio().post(
        url,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
        data: model.toJson(),
      );
      print(response.data);
      if (response.statusCode == 200) {
        isOrderCreated = true;
      }
    } on DioError catch (e) {
      print(e.message);
      isOrderCreated = false;
    }

    return isOrderCreated;
  }

  Future<List<OrderModel>> getOrders() async {
    List<OrderModel> orders = new List<OrderModel>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var url = Config.customerURL + Config.orderListURL;

      print(url);
      var response = await Dio().post(
        url,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
      );
      print(response);
      if (response.statusCode == 200) {
        for (dynamic item in response.data['data']) {
          OrderModel _order = OrderModel.fromJson(item);
          orders.add(_order);
        }
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return orders;
  }

  Future<List<OrderModel>> getGroceryOrders(String groceryId) async {
    List<OrderModel> orders = new List<OrderModel>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      'customer_id': prefs.getString('id'),
      'grocery_id': groceryId,
    };
    try {
      var url = Config.customerURL + 'groceryOrders';

      print(url);
      var response = await Dio().post(
        url,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
        data: data,
      );
      print(response);
      if (response.statusCode == 200) {
        for (dynamic item in response.data['data']) {
          OrderModel _order = OrderModel.fromJson(item);
          orders.add(_order);
        }
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return orders;
  }

  Future<Order> getOrder(int orderId) async {
    Order order = new Order();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      'orderId': orderId,
    };
    try {
      var url = Config.customerURL + Config.orderURL;

      print(url);
      var response = await Dio().post(
        url,
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
        data: data,
      );
      print(response);
      if (response.statusCode == 200) {
        order = Order.fromJson(response.data['data']);
        print(order.id);
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return order;
  }
}
