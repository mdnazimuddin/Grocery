class StripeAccount {
  String groceryId;
  String publishableKey;
  String secret;
  String merchantId;
  String androidPayMode;

  StripeAccount(
      {this.groceryId,
      this.publishableKey,
      this.secret,
      this.merchantId,
      this.androidPayMode});

  StripeAccount.fromJson(Map<String, dynamic> json) {
    groceryId = json['grocery_id'].toString();
    publishableKey = json['publishable_key'];
    secret = json['secret_key'];
    merchantId = json['merchantId'];
    androidPayMode = json['androidPayMode'];
  }
}
