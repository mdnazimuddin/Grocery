class OrderTax {
  String groceryId;
  double uthbayService;
  double productTax;
  String delivery;
  OrderTax(
      {this.groceryId, this.uthbayService, this.productTax, this.delivery});
  OrderTax.fromJson(Map<String, dynamic> json) {
    this.groceryId = json['grocery_id'].toString();
    this.uthbayService = double.parse(json['uthbay_service']);
    this.productTax = double.parse(json['product_tax']);
    this.delivery = json['delivery'];
  }
}
