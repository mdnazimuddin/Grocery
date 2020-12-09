class GroceryList {
  String id;
  String name;
  String slug;
  String logo;
  String cover_img;
  bool opening_status;
  bool claimed;
  String rating;
  GroceryAddress address;
  Href href;
  GroceryList({
    this.id,
    this.name,
    this.slug,
    this.logo,
    this.cover_img,
    this.opening_status,
    this.claimed,
    this.rating,
    this.address,
    this.href,
  });
  GroceryList.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    slug = json['slug'];
    logo = json['logo'];
    cover_img = json['cover_img'];
    opening_status = json['opening_status'];
    claimed = json['claimed'];
    rating = json['rating'].toString();
    address = json['address'] != null
        ? new GroceryAddress.formJson(json['address'])
        : null;
    href = json['href'] != null ? new Href.formJson(json['href']) : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['cover_img'] = this.cover_img;
    data['logo'] = this.logo;
    data['opening_status'] = this.opening_status;
    data['claimed'] = this.claimed;
    data['rating'] = this.rating;

    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    if (this.href != null) {
      data['href'] = this.href.toJson();
    }
    return data;
  }
}

class GroceryAddress {
  String address_1;
  String address_2;
  String city;
  String state;
  String zip;
  String latitude;
  String longitude;
  GroceryAddress({
    this.address_1,
    this.address_2,
    this.city,
    this.state,
    this.zip,
    this.latitude,
    this.longitude,
  });
  GroceryAddress.formJson(Map<String, dynamic> json) {
    address_1 = json['address_1'];
    address_2 = json['address_2'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_1'] = this.address_1;
    data['address_2'] = this.address_2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip'] = this.zip;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;

    return data;
  }
}

class Href {
  String link;
  Href({
    this.link,
  });
  Href.formJson(Map<String, dynamic> json) {
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;

    return data;
  }
}
