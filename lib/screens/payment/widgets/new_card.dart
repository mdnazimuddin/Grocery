import 'package:Uthbay/services/payment_service.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:Uthbay/models/credit_card_model.dart';
import 'package:Uthbay/screens/payment/widgets/credit_card_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stripe_payment/stripe_payment.dart';

class NewCardsPage extends StatefulWidget {
  @override
  _NewCardsPageState createState() => _NewCardsPageState();
}

class _NewCardsPageState extends State<NewCardsPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CreditCardFormWidget(
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin:
                            const EdgeInsets.only(left: 16, top: 8, right: 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                              onPressed: () => onPressedPayButton(context),
                              color: Colors.blue[900],
                              child: Text(
                                "Pay with Card",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  void onPressedPayButton(BuildContext context) {
    if (cardNumber.isEmpty ||
        expiryDate.isEmpty ||
        cardHolderName.isEmpty ||
        cvvCode.isEmpty) {
      final snackBar = SnackBar(
          content: Text("Wrong! Empty Card Fild"),
          duration: new Duration(milliseconds: 1200));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else {
      var card = {
        'cardNumber': cardNumber,
        'expiryDate': expiryDate,
        'cardHolderName': cardHolderName,
        'cvvCode': cvvCode,
        'showBackView': false,
      };

      return payViaExistingCard(context, card);
    }
  }

  payViaExistingCard(BuildContext context, card) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var expiryArr = card['expiryDate'].split('/');
    CreditCard stripeCard = CreditCard(
      number: card['cardNumber'],
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
    );
    var response = await StripeService.payViaExistingCard(
        amount: '2500', currency: 'USD', card: stripeCard);
    await dialog.hide();
    final snackBar = SnackBar(
        content: Text(response.message),
        duration: new Duration(milliseconds: 1200));
    _scaffoldKey.currentState.showSnackBar(snackBar).closed.then((_) {
      Navigator.pop(context);
    });
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.redAccent,
      brightness: Brightness.dark,
      elevation: 0,
      automaticallyImplyLeading: true,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context)),
      title: Text(
        "Pay New Card",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
