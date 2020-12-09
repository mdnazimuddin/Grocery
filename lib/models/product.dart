import 'package:Uthbay/models/grocery.dart';

class Product {
  String id;
  String groceriyID;
  String name;
  String sku;
  String price;
  String regularPrice;
  String salePrice;
  String stockStatus;
  String description;
  String sortDescription;
  List<ProductImage> images;
  List<Category> categories;
  Product({
    this.id,
    this.groceriyID,
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
    id = json['id'];
    groceriyID = json['grocery_id'];
    name = json['name'];
    sku = json['sku'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    stockStatus = json['stock_status'];
    description = json['description'];
    sortDescription = json['sort_description'];

    if (json['categories'] != null) {
      categories = new List<Category>();
      json['categories'].forEach((v) {
        categories.add(new Category.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = new List<ProductImage>();
      json['images'].forEach((v) {
        images.add(new ProductImage.fromJson(v));
      });
    }
  }
}

class ProductImage {
  String src;
  ProductImage({this.src});
  ProductImage.fromJson(Map<String, dynamic> json) {
    src = json['src'];
  }
}
