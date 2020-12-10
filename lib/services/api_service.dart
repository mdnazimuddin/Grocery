import 'package:Uthbay/models/customer.dart';
import 'package:Uthbay/models/customer_address.dart';
import 'package:Uthbay/models/grocery.dart';
import 'package:Uthbay/models/grocery_list.dart';
import 'package:Uthbay/models/login_model.dart';
import 'package:Uthbay/models/product.dart';
import 'package:Uthbay/models/tag.dart';
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
        prefs.setString('name', response.data['success']['name'].toString());
        prefs.setString('email', response.data['success']['email'].toString());
        prefs.setString(
            'img_src', response.data['success']['img_src'].toString());
        prefs.setBool('login', true);
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
        prefs.setString('name', response.data['success']['name'].toString());
        prefs.setString('email', response.data['success']['email'].toString());
        prefs.setString(
            'img_src', response.data['success']['img_src'].toString());
        prefs.setBool('login', true);
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

  Future<bool> logoutCustomer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool ret = false;
    try {
      var response = await Dio().post(
        Config.customerURL + 'logout',
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
      );
      print(response);
      if (response.statusCode == 200) {
        ret = true;
        prefs.setString('token', null);
        prefs.setString('id', null);
        prefs.setString('name', null);
        prefs.setString('email', null);
        prefs.setString('img_src', null);
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

      if (response.statusCode == 200) {
        List<String> addressList = [
          response.data['success']['address_1'],
          response.data['success']['address_2'],
          response.data['success']['city'],
          response.data['success']['state'],
          response.data['success']['zip'],
          response.data['success']['country'],
          response.data['success']['latitude'],
          response.data['success']['longitude']
        ];
        print(addressList);
        prefs.setStringList('address', addressList);
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
    bool ret = false;
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
          response.data['success']['address_1'],
          response.data['success']['address_2'],
          response.data['success']['city'],
          response.data['success']['state'],
          response.data['success']['zip'],
          response.data['success']['country'],
          response.data['success']['latitude'],
          response.data['success']['longitude']
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

  Future<CustomerAddress> getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CustomerAddress customerAddress = new CustomerAddress();
    bool ret = false;
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
          response.data['success']['address_1'],
          response.data['success']['address_2'],
          response.data['success']['city'],
          response.data['success']['state'],
          response.data['success']['zip'],
          response.data['success']['country'],
          response.data['success']['latitude'],
          response.data['success']['longitude']
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

  Future<List<GroceryList>> getGroceriesList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<GroceryList> groceriesList = new List<GroceryList>();
    try {
      var response = await Dio().post(
        Config.customerURL + 'groceries',
        options: new Options(headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('token'),
        }),
      );
      if (response.statusCode == 200) {
        for (var item in response.data['success']) {
          GroceryList groceries = GroceryList.fromJson(item);
          groceriesList.add(groceries);
        }
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
        grocery = Grocery.fromJson(response.data);
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
    dynamic tagId,
    dynamic categoryId,
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
      if (tagId != null) {
        parameter += "&tag=$tagId";
      }
      if (categoryId != null) {
        parameter += "&category=$categoryId";
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
      if (response.statusCode == 200) {
        for (dynamic item in response.data['data']) {
          Product _product = Product.fromJson(item);
          products.add(_product);
        }
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return products;
  }
}
