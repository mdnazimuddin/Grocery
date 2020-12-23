import 'package:Uthbay/models/shipping_model.dart';

class OrderDetailModel {
  int orderId;
  String orderNumber;
  String paymentMethod;
  String orderStatus;
  DateTime orderDate;
  Shipping shipping;
  List<LineItems> lineItems;
  double totalAmount;
  double shippingTotal;
  double itemTotalAmount;
  OrderDetailModel({
    this.orderId,
    this.orderNumber,
    this.paymentMethod,
    this.orderStatus,
    this.orderDate,
    this.shipping,
    this.lineItems,
    this.totalAmount,
    this.shippingTotal,
    this.itemTotalAmount,
  });

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    orderId = json['id'];
    orderNumber = json['order_key'];
    paymentMethod = json['payment_method_title'];
    orderStatus = json['status'];
    orderDate = DateTime.parse(json['created_at']);
    shipping = json['shipping'] != null
        ? new Shipping.fromJson(json['shipping'])
        : null;
    if (json['line_items'] != null) {
      lineItems = new List<LineItems>();
      json['line_items'].forEach((v) {
        lineItems.add(new LineItems.fromJson(v));
      });
      itemTotalAmount = lineItems != null
          ? lineItems.map<double>((m) => m.totalAmount).reduce((a, b) => a + b)
          : 0;
    }
    totalAmount = double.parse(json['total']);
    shippingTotal = double.parse(json['shipping_total']);
  }
}

class LineItems {
  int productId;
  String productName;
  int quantity;
  int variationId;
  double totalAmount;

  LineItems({
    this.productId,
    this.productName,
    this.quantity,
    this.variationId,
    this.totalAmount,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    if (this.variationId != null) {
      data['variation_id'] = this.variationId;
    }
    return data;
  }

  LineItems.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['name'];
    quantity = json['quantity'];
    variationId = json['variation_id'] ?? null;
    totalAmount = double.parse(json['total']);
  }
}
