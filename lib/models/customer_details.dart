import 'package:Uthbay/models/shipping_model.dart';

class CustomerDetails {
  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  Shipping shipping;

  CustomerDetails({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.shipping,
  });
  CustomerDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    print("Address:");
    print(json);
    shipping =
        json['address'] != null ? new Shipping.fromJson(json['address']) : null;
  }
}

class ShippingModel {
  String address1;
  String address2;
  String city;
  String postcode;
  String country;
  String state;

  ShippingModel({
    this.address1,
    this.address2,
    this.city,
    this.postcode,
    this.country,
    this.state,
  });

  ShippingModel.fromJson(Map<String, dynamic> json) {
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    country = json['country'];
    state = json['state'];
    postcode = json['zip'];
  }
  Map<String, dynamic> tojson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_1'] = this.address1;
    data['address_2'] = this.address2;
    data['city'] = this.city;
    data['country'] = this.country;
    data['state'] = this.state;
    data['zip'] = this.postcode;
    return data;
  }
}
