
class CartRequestModel {
  int userId;
  int groceryId;
  List<CartProducts> products;

  CartRequestModel({this.userId, this.products});

  CartRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['customer_id'];
    groceryId = json['grocery_id'];
    if (json['products'] != null) {
      products = new List<CartProducts>();
      json['products'].forEach((v) {
        products.add(new CartProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.userId;
    data['grocery_id'] = this.groceryId;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartProducts {
  int productId;
  int quantity;
  int variationId = 0;
  CartProducts({this.productId, this.quantity, this.variationId});

  CartProducts.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    quantity = json['quantity'];
    variationId = json['variation_id'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['variation_id'] = this.variationId;
    return data;
  }
}
