import 'package:Uthbay/models/shipping_model.dart';

class OrderModel {
  int customerId;
  int groceryId;
  String paymentMethod;
  String paymentMethodTitle;
  bool setPaid;
  String transactionId;
  List<LineItems> lineItems;

  int orderId;
  String orderNumber;
  String status;
  DateTime orderDate;
  Shipping shipping;

  OrderModel({
    this.customerId,
    this.groceryId,
    this.paymentMethod,
    this.paymentMethodTitle,
    this.setPaid,
    this.transactionId,
    this.lineItems,
    this.orderId,
    this.orderNumber,
    this.status,
    this.orderDate,
    this.shipping,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    groceryId = json['grocery_id'];
    orderId = json['id'];
    orderNumber = json['order_number'];
    status = json['status'];
    orderDate = DateTime.parse(json['created_at']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['customer_id'] = customerId;
    data['payment_method'] = paymentMethod;
    data['payment_method_title'] = paymentMethodTitle;
    data['set_paid'] = setPaid;
    data['transaction_id'] = transactionId;
    data['shipping'] = shipping.tojson();

    if (lineItems != null) {
      data['line_items'] = lineItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LineItems {
  int productId;
  int quantity;
  int variationId;
  LineItems({this.productId, this.quantity, this.variationId});
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
    quantity = json['quantity'];
    variationId = json['variation_id'] ?? null;
  }
}
