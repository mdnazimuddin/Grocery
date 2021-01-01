class StripeTransactionResponse {
  String message;
  bool success;
  String transactionId;
  String brand;
  StripeTransactionResponse(
      {this.message, this.success, this.transactionId, this.brand});
}
