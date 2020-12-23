class PaymentMethod {
  String id;
  String name;
  String description;
  String logo;
  String route;
  Function onTap;
  bool isRouteRedirect;

  PaymentMethod(
    this.id,
    this.name,
    this.description,
    this.logo,
    this.route,
    this.onTap,
    this.isRouteRedirect,
  );
}

class PaymentMethodList {
  List<PaymentMethod> _paymentList;
  List<PaymentMethod> _cashList;

  PaymentMethodList() {
    this._paymentList = [
      new PaymentMethod(
        "paypal",
        "PayPal",
        "Click to pay with Paypal Method",
        "assets/images/paypal.png",
        "/PayPal",
        () {},
        true,
      ),
      new PaymentMethod(
        "stripe",
        "Stripe",
        "Click to pay with Stripe Method",
        "assets/images/stripe.png",
        "/Stripe",
        () {},
        false,
      ),
    ];
    this._cashList = [
      new PaymentMethod(
        "cod",
        "Cash on Delivery",
        "Click to pay cash on delivery",
        "assets/images/cash.png",
        "/OrderSuccess",
        () {},
        false,
      ),
    ];
  }
  List<PaymentMethod> get paymentsList => _paymentList;
  List<PaymentMethod> get cashList => _cashList;
}
