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
    // var response =
    //     await Dio().post("https://grocery.uthbay.com/api/customer/details",
    //         options: new Options(headers: {
    //           'Accept': 'application/json',
    //           'Authorization':
    //               'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZmM1ZjRiNmUwZWFhM2UxODk2ZWY2OGEwMTUyZDE0NWJkOTY5NjI0ZTBiODFhYTJhZTYxNjc3YWI0MWFmMzJhM2VjZWI3MmRjNGFjMDc3ODIiLCJpYXQiOjE2MDczMDcxNTcsIm5iZiI6MTYwNzMwNzE1NywiZXhwIjoxNjM4ODQzMTU3LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.EzydjuZNRdTIoYBu12Dspso2pfUFV_WvtYUi8r-r7zI8hjzv1LNBtstaunnindNadsSsvg_mhuMkbY4zF4aF_AsbQxBGswYZ8UT7pgxYUKZMvvMr8q9t7ecxojjmiDTy3LUbhL3Z5fmuE8r4X3vo_r2Nf5zmg42PgeNEEVSMQ8RwTZRPnkarHFoz9eu--adkH0rPWxucVJDVqh5rZE3pHP88OmkksD_jIqdPzAqFx_Knv14XDjx8AJ9po0Cgpd029S5iHOZRKqpRRzqcwj9yonHl_JALhrqcMO77qGXmtewDW942DFQhdRg8E9zaY62jIW9eyGf_qqxrlLxz-k6m4YqE8hWxc9AmNxfYmY7lxfOmYMa49C3wjRbxViSUffJKzPUHSORnNBWAH5EYGJYm8fJARlghoko-9hO79gi_3RUn2WuZpsIAN1AC4ah4ZHNA_m32GNN3efAobl5GUjN63H5WpuYVeHUW2u4Qf75tq9z0AUqB6saFkFDvfMtnVOP2zb-8rrfNbxl1TUcV-pafP9I1O5ZdaElpzAeeZ-0vSK_6LUmLSfrixUlfzQRtGBwoHQm1fxbA49UtOX7Nx12F0s6i--QhZDNgqx5pFBU_an3HiSW87S0j0mcB1a3m7MBOQVAxFwrCiw6u53uKjng0DV1mjMFgIm3TqfAv-mGFxfo'
    //         }),
    //         data: {
    //       "email": "test@gmail.com",
    //       "password": "12345678",
    //     });

    // var response = await Dio().get("https://grocery.uthbay.com/api/groceries");
    // print(response.data['success']['token']);
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

  Future<List<Product>> getProductWithTags(String tagId) async {
    List<Product> products = new List<Product>();

    var productUrl = Config.tagURL + tagId + '/products';
    print(productUrl);
    try {
      var response = await Dio().get(productUrl);
      if (response.statusCode == 200) {
        for (var item in response.data['data']) {
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
