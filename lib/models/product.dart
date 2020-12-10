class Product {
  dynamic id;
  dynamic groceryID;
  dynamic name;
  dynamic sku;
  dynamic price;
  dynamic regularPrice;
  dynamic salePrice;
  dynamic stockStatus;
  dynamic description;
  dynamic sortDescription;
  List<ProductImage> images;
  List<ProductCategory> categories;
  Product({
    this.id,
    this.groceryID,
    this.name,
    this.sku,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.stockStatus,
    this.description,
    this.sortDescription,
    this.images,
    this.categories,
  });
  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    groceryID = json['grocery_id'].toString();
    name = json['name'];
    sku = json['sku'];
    regularPrice = json['regular_price'];
    salePrice =
        json['sale_price'] != "" ? json['sale_price'] : json['regular_price'];
    stockStatus = json['stock_status'];
    description = json['description'];
    sortDescription = json['sort_description'];

    if (json['categories'] != null) {
      categories = new List<ProductCategory>();
      json['categories'].forEach((v) {
        categories.add(new ProductCategory.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = new List<ProductImage>();
      json['images'].forEach((v) {
        images.add(new ProductImage.fromJson(v));
      });
    }
  }
  calculateDiscount() {
    dynamic regularPrice = double.parse(this.regularPrice);
    dynamic salePrice =
        this.salePrice != "" ? double.parse(this.salePrice) : regularPrice;
    dynamic discount = regularPrice - salePrice;
    dynamic disPercent = (discount / regularPrice) * 100;

    return disPercent.round();
  }
}

class ProductImage {
  dynamic src;
  ProductImage({this.src});
  ProductImage.fromJson(Map<String, dynamic> json) {
    src = json['src'];
  }
}

class ProductCategory {
  dynamic id;
  dynamic name;
  dynamic img;
  ProductCategory({
    this.id,
    this.name,
    this.img,
  });
  ProductCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
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
