import 'package:Uthbay/models/shipping_model.dart';

import 'cart_response_model.dart';

class Order {
  int id;
  int customerId;
  int groceryId;
  String firstName;
  String lastName;

  String orderNumber;
  DateTime orderDate;

  String itemTotal;
  String productTax;
  String delivery;
  String uthbayService;
  String totalAmount;

  String status;
  String pickup;

  Shipping shipping;
  Billing billing;
  Payment payment;
  List<CartItem> items;

  Order({
    this.id,
    this.customerId,
    this.groceryId,
    this.firstName,
    this.lastName,
    this.orderNumber,
    this.orderDate,
    this.itemTotal,
    this.productTax,
    this.delivery,
    this.uthbayService,
    this.totalAmount,
    this.status,
    this.pickup,
    this.shipping,
    this.billing,
    this.payment,
    this.items,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    groceryId = json['grocery_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    orderNumber = json['order_number'];
    orderDate = DateTime.parse(json['order_date']);
    itemTotal = json['item_total'];
    productTax = json['product_tax'];
    delivery = json['delivery'];
    uthbayService = json['uthbay_service'];
    totalAmount = json['total_amount'];
    status = json['status'];
    pickup = json['pickup'];
    shipping =
        json['shipping'] != null ? Shipping.fromJson(json['shipping']) : null;
    billing =
        json['billing'] != null ? Billing.fromJson(json['billing']) : null;
    payment =
        json['payment'] != null ? Payment.fromJson(json['payment']) : null;
    print("Test: ${json['items']}");
    if (json['items'] != null) {
      items = new List<CartItem>();
      for (var item in json['items']) {
        print(item);
        items.add(new CartItem.fromJson(item));
      }
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['customer_id'] = customerId;
    data['grocery_id'] = groceryId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['order_number'] = orderNumber;
    data['order_date'] = orderDate;
    data['item_total'] = itemTotal;
    data['product_tax'] = productTax;
    data['delivery'] = delivery;
    data['uthbay_service'] = uthbayService;
    data['total_amount'] = totalAmount;
    data['status'] = status;
    data['pickup'] = pickup;
    data['shipping'] = shipping.tojson();
    data['billing'] = billing.tojson();
    data['payment'] = payment.toJson();

    if (items != null) {
      data['items'] = items.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Payment {
  String paymentMethod;
  String paymentMethodTitle;
  bool setPaid;
  String transactionId;
  Payment({
    this.paymentMethod,
    this.paymentMethodTitle,
    this.setPaid,
    this.transactionId,
  });

  Payment.fromJson(Map<String, dynamic> json) {
    paymentMethod = json['paymentMethod'];
    paymentMethodTitle = json['paymentMethodTitle'];
    setPaid = json['setPaid'];
    transactionId = json['transactionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['paymentMethod'] = paymentMethod;
    data['paymentMethodTitle'] = paymentMethodTitle;
    data['setPaid'] = setPaid;
    data['transactionId'] = transactionId;

    return data;
  }
}

class Billing {
  int id;
  String firstName;
  String lastName;
  String company;
  String address1;
  String address2;
  String city;
  String postcode;
  String country;
  String state;
  String email;
  String phone;

  Billing({
    this.id,
    this.firstName,
    this.lastName,
    this.company,
    this.address1,
    this.address2,
    this.city,
    this.postcode,
    this.country,
    this.state,
    this.email,
    this.phone,
  });

  Billing.fromJson(Map<String, dynamic> json) {
    company = json['company'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    country = json['country'];
    state = json['state'];
    postcode = json['zip'];
    email = json['email'];
    phone = json['phone'];
  }
  Map<String, dynamic> tojson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company'] = this.company;
    data['address_1'] = this.address1;
    data['address_2'] = this.address2;
    data['city'] = this.city;
    data['country'] = this.country;
    data['state'] = this.state;
    data['zip'] = this.postcode;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}
