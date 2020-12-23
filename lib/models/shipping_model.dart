class Shipping {
  String address1;
  String address2;
  String city;
  String postcode;
  String country;
  String state;
  String email;
  String phone;

  Shipping({
    this.address1,
    this.address2,
    this.city,
    this.postcode,
    this.country,
    this.state,
    this.email,
    this.phone,
  });

  Shipping.fromJson(Map<String, dynamic> json) {
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    country = json['country'];
    state = json['state'];
    postcode = json['zip'];
    email = json['email'];
    phone = json['phone'];
  }
  Map<String, dynamic> tojson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_1'] = this.address1;
    data['address_2'] = this.address2;
    data['city'] = this.city;
    data['country'] = this.country;
    data['state'] = this.state;
    data['zip'] = this.postcode;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}
