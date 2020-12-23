class OrderTax {
  int groceryId;
  double uthbayService;
  double productTax;
  String delivery;
  OrderTax(
      {this.groceryId, this.uthbayService, this.productTax, this.delivery});
  OrderTax.fromJson(Map<String, dynamic> json) {
    this.groceryId = json['grocery_id'];
    this.uthbayService = double.parse(json['uthbay_service']);
    this.productTax = double.parse(json['product_tax']);
    this.delivery = json['delivery'];
  }
}
