class CreditCardModel {
  CreditCardModel(
      {this.cardNumber,
      this.expiryDate,
      this.cardHolderName,
      this.cvvCode,
      this.isCvvFocused});

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['cardNumber'] = this.cardNumber;
    data['expiryDate'] = this.expiryDate;
    data['cardHolderName'] = this.cardHolderName;
    data['cvvCode'] = this.cvvCode;
    data['isCvvFocused'] = this.isCvvFocused;

    return data;
  }

  CreditCardModel.fromJson(Map<String, dynamic> json) {
    this.cardNumber = json['cardNumber'];
    this.expiryDate = json['expiryDate'];
    this.cardHolderName = json['cardHolderName'];
    this.cvvCode = json['cvvCode'];
    this.isCvvFocused = json['isCvvFocused'];
  }
}
