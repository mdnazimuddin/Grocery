import 'package:Uthbay/models/product.dart';

class VariableProduct {
  String id;
  String sku;
  String price;
  String regularPrice;
  String salePrice;
  List<Attributes> attributes;

  VariableProduct({
    this.id,
    this.sku,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.attributes,
  });

  VariableProduct.fromJson(Map<String, dynamic> json) {
    print(json['price']);
    id = json['id'].toString();
    sku = json['sku'].toString();
    price = json['price'].toString();
    regularPrice = json['regular_price'].toString();
    salePrice = json['sale_price'].toString();
    if (json['attributes'] != null) {
      attributes = new List<Attributes>();
      Attributes _attributes = Attributes(
          name: json['attributes']['name'],
          option: json['attributes']['option']);
      attributes.add(_attributes);
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sku'] = this.sku;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;

    if (this.attributes != null) {
      data['attributes'] = this.attributes.map((v) => v.toString()).toList();
    }
    return data;
  }
}

class Attributes {
  dynamic name;
  dynamic option;

  Attributes({this.name, this.option});
  Attributes.fromJson(Map<String, dynamic> json) {
    name = json['name'].toString();
    option = json['option'].toString();
  }
}
