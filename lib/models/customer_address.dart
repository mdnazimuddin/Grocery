class CustomerAddress {
  String address_1;
  String address_2;
  String city;
  String state;
  String zip;
  String country;
  String latitude;
  String longitude;
  CustomerAddress(
      {this.address_1,
      this.address_2,
      this.city,
      this.state,
      this.zip,
      this.country,
      this.latitude,
      this.longitude});

  Map<String, dynamic> toMap(List<String> address) {
    Map<String, dynamic> map = {};

    map.addAll({
      'address_1': address[0],
      'address_2': address[1],
      'city': address[2],
      'state': address[3],
      'zip': address[4],
      'country': address[5],
      'latitude': address[6],
      'longitude': address[7]
    });
    return map;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.addAll({
      'address_1': address_1,
      'address_2': address_2,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
      'latitude': latitude,
      'longitude': longitude
    });
    return map;
  }
}
