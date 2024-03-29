import 'package:Uthbay/models/shipping_model.dart';

class CustomerDetailsModel {
  int id;
  String firstName;
  String lastName;
  Billing billing;
  Shipping shipping;

  CustomerDetailsModel({
    this.firstName,
    this.lastName,
    this.billing,
    this.shipping,
  });
  CustomerDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];

    billing =
        json['billing'] != null ? new Billing.fromJson(json['billing']) : null;
    shipping = json['shipping'] != null
        ? new Shipping.fromJson(json['shipping'])
        : null;
  }
}

class Billing {
  int id;
  String firstName;
  String lastName;
  String company;
  String address1;
  String address2;
  String city;
  String postcode;
  String country;
  String state;
  String email;
  String phone;

  Billing({
    this.id,
    this.firstName,
    this.lastName,
    this.company,
    this.address1,
    this.address2,
    this.city,
    this.postcode,
    this.country,
    this.state,
    this.email,
    this.phone,
  });

  Billing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    company = json['company'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    country = json['country'];
    state = json['state'];
    email = json['email'];
    phone = json['phone'];
  }
  Map<String, dynamic> tojson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['company'] = this.company;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['city'] = this.city;
    data['country'] = this.country;
    data['state'] = this.state;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}
