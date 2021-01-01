class PaymentSystem {
  String groceryId;
  bool stripe;
  bool paypal;
  bool cod;

  PaymentSystem({this.groceryId, this.stripe, this.cod, this.paypal});

  PaymentSystem.fromJson(Map<String, dynamic> json) {
    this.groceryId = json['grocery_id'].toString();
    this.stripe = json['stripe'];
    this.paypal = json['paypal'];
    this.cod = json['cod'];
  }
}
