class Grocery {
  String id;
  String name;
  String slug;
  String logo;
  String cover_img;
  bool opening_status;
  bool claimed;
  String rating;
  GroceryAddress address;
  SliderImages slider_image;
  List images;
  Category categories;
  Href href;
  Grocery({
    this.id,
    this.name,
    this.slug,
    this.logo,
    this.cover_img,
    this.opening_status,
    this.claimed,
    this.rating,
    this.address,
    this.slider_image,
    this.images,
    this.categories,
    this.href,
  });
  Grocery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    logo = json['logo'];
    cover_img = json['cover_img'];
    opening_status = json['opening_status'];
    claimed = json['claimed'];
    rating = json['rating'];
    images = json['slider_image'];
    address = json['address'] != null
        ? new GroceryAddress.formJson(json['address'])
        : null;
    slider_image = json['slider_image'] != null
        ? new SliderImages.fromJson(json['slider_image'])
        : null;
    categories = json['categories'] != null
        ? new Category.fromJson(json['categories'])
        : null;
    href = json['href'] != null ? new Href.fromJson(json['href']) : null;
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
    data['images'] = this.images;

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

class SliderImages {
  String img_name;
  String src;
  SliderImages({
    this.img_name,
    this.src,
  });
  SliderImages.fromJson(Map<String, dynamic> json) {
    img_name = json['img_name'];
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img_name'] = this.img_name;
    data['src'] = this.src;

    return data;
  }
}

class Category {
  int id;
  String name;
  String img;
  Category({
    this.id,
    this.name,
    this.img,
  });
  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['img'] = this.img;

    return data;
  }
}

class Href {
  String products;
  String reviews;
  String opening_hours;
  Href({
    this.products,
    this.reviews,
    this.opening_hours,
  });
  Href.fromJson(Map<String, dynamic> json) {
    products = json['products'];
    reviews = json['reviews'];
    opening_hours = json['opening_hours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['products'] = this.products;
    data['reviews'] = this.reviews;
    data['opening_hours'] = this.opening_hours;

    return data;
  }
}
