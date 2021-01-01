class CartResponseModel {
  int status;
  List<CartItem> data;

  CartResponseModel({this.status, this.data});

  CartResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<CartItem>();
      for (var item in json['data']) {
        data.add(new CartItem.fromJson(item));
      }
      // json['data'].forEash((v) {
      //   data.add(new CartItem.fromJson(v));
      // });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItem {
  int productId;
  String productName;
  String productRegularPrice;
  String productSalePrice;
  String thumbnail;
  int qty;
  double lineSubtotal;
  double lineTotal;
  int variationId;
  String attribute;
  String attributeValue;

  CartItem({
    this.productId,
    this.productName,
    this.productRegularPrice,
    this.productSalePrice,
    this.thumbnail,
    this.qty,
    this.lineSubtotal,
    this.lineTotal,
    this.variationId,
    this.attribute,
    this.attributeValue,
  });
  CartItem.fromJson(Map<String, dynamic> json) {
    productId = int.parse(json['product_id']);
    productName = json['product_name'];
    productRegularPrice = json['product_regular_price'];
    productSalePrice = json['product_sale_price'];
    thumbnail = json['thumbnail'];
    qty = int.parse(json['qty']);
    lineSubtotal = double.parse(json['line_subtotal'].toString());
    lineTotal = double.parse(json['line_total'].toString());
    variationId = json['variation_id'];
    attribute = (json['attribute'] != null)
        ? json['attribute'].keys.first.toString()
        : "";
    attributeValue = (json['attribute'] != null)
        ? json['attribute'].values.first.toString()
        : "";
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_regular_price'] = this.productRegularPrice;
    data['product_sale_price'] = this.productSalePrice;
    data['thumbnail'] = this.thumbnail;
    data['qty'] = this.qty;
    data['line_subtotal'] = this.lineSubtotal;
    data['line_total'] = this.lineTotal;
    data['variation_id'] = this.variationId;
    data['attribute'] = "${this.attribute}, ${this.attributeValue}";
    return data;
  }
}
