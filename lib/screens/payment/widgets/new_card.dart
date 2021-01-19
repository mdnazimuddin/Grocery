import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/provider/customer_provider.dart';
import 'package:Uthbay/provider/grocery_provider.dart';
import 'package:Uthbay/screens/checkout/components/order_success.dart';
import 'package:Uthbay/services/payment_service.dart';
import 'package:Uthbay/models/order.dart';
import 'package:Uthbay/models/credit_card_model.dart';
import 'package:Uthbay/screens/payment/widgets/credit_card_form.dart';
import 'package:Uthbay/utilis/show_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
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
    // StripeService.init();
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
          content: Text("Wrong! Empty Card failed"),
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
      AlertMessage.showMessage(
        context,
        "Uthbay Grocery",
        "Do you want to save your card for the next transaction?",
        "Yes",
        () {
          Navigator.of(context).pop();
          return payViaExistingCard(context, card, true);
        },
        buttonText2: "No",
        isConfirmationDialog: true,
        onPressed2: () {
          Navigator.of(context).pop();
          return payViaExistingCard(context, card, false);
        },
      );
    }
  }

  payViaExistingCard(BuildContext context, card, isCardSave) async {
    var cart = Provider.of<CartProvider>(context, listen: false);
    String total =
        ((double.parse(cart.orderModel.totalAmount) * 100).toInt()).toString();
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
        amount: total, currency: 'USD', card: stripeCard);
    if (isCardSave && response.success) {
      var creditCardModel = CreditCardModel(
        cardHolderName: this.cardHolderName,
        cardNumber: this.cardNumber,
        cvvCode: this.cvvCode,
        expiryDate: this.expiryDate,
        isCvvFocused: isCvvFocused,
      );
      Provider.of<CustomerProvider>(context, listen: false)
          .savecreditCard(creditCardModel);
    }
    await dialog.hide();
    if (response.success) {
      cart.orderModel.payment = Payment();
      cart.orderModel.payment.paymentMethod = response.brand;
      cart.orderModel.payment.paymentMethodTitle = 'Stripe';
      cart.orderModel.payment.setPaid = true;
      cart.orderModel.payment.transactionId = response.transactionId;

      cart.orderModel.status = 'pending';

      final snackBar = SnackBar(
          content: Text(response.message),
          duration: new Duration(milliseconds: 1200));
      _scaffoldKey.currentState.showSnackBar(snackBar).closed.then((_) {
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: OrderSuccess()));
      });
    } else {
      final snackBar = SnackBar(
          content: Text(response.message),
          duration: new Duration(milliseconds: 1200));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
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

// void onPressedPayButton(BuildContext context) {
//     if (cardNumber.isEmpty ||
//         expiryDate.isEmpty ||
//         cardHolderName.isEmpty ||
//         cvvCode.isEmpty) {
//       final snackBar = SnackBar(
//           content: Text("Wrong! Empty Card Fild"),
//           duration: new Duration(milliseconds: 1200));
//       _scaffoldKey.currentState.showSnackBar(snackBar);
//     } else {
//       var card = {
//         'cardNumber': cardNumber,
//         'expiryDate': expiryDate,
//         'cardHolderName': cardHolderName,
//         'cvvCode': cvvCode,
//         'showBackView': false,
//       };
//       AlertMessage.showMessage(
//         context,
//         "Uthbay Grocery",
//         "Do you want to save your card for the next transaction?",
//         "Yes",
//         () {
//           Navigator.of(context).pop();
//           return payViaExistingCard(context, card, true);
//         },
//         buttonText2: "No",
//         isConfirmationDialog: true,
//         onPressed2: () {
//           Navigator.of(context).pop();
//           return payViaExistingCard(context, card, false);
//         },
//       );
//     }
//   }

//   payViaExistingCard(BuildContext context, card, isCardSave) async {
//     var cart = Provider.of<CartProvider>(context, listen: false);
//     String total =
//         ((double.parse(cart.orderModel.totalAmount) * 100).toInt()).toString();
//     print(total);
//     ProgressDialog dialog = new ProgressDialog(context);
//     dialog.style(message: 'Please wait...');
//     await dialog.show();
//     var expiryArr = card['expiryDate'].split('/');
//     CreditCard stripeCard = CreditCard(
//       number: card['cardNumber'],
//       expMonth: int.parse(expiryArr[0]),
//       expYear: int.parse(expiryArr[1]),
//     );

//     var response = await StripeService.payViaExistingCard(
//         amount: '1000', currency: 'USD', card: stripeCard);
//     // if (response.success && isCardSave) {
//     //   var creditCardModel = CreditCardModel(
//     //     cardNumber: this.cardNumber,
//     //     cardHolderName: this.cardHolderName,
//     //     cvvCode: this.cvvCode,
//     //     expiryDate: this.expiryDate,
//     //   );
//     //   Provider.of<CustomerProvider>(context, listen: false)
//     //       .savecreditCard(creditCardModel);
//     // }
//     await dialog.hide();
//     if (response.success) {
//       cart.orderModel.payment = Payment();
//       cart.orderModel.payment.paymentMethod = response.brand;
//       cart.orderModel.payment.paymentMethodTitle = 'Stripe';
//       cart.orderModel.payment.setPaid = true;
//       cart.orderModel.payment.transactionId = response.transactionId;

//       cart.orderModel.status = 'pending';
//       final snackBar = SnackBar(
//           content: Text(response.message),
//           duration: new Duration(milliseconds: 800));
//       _scaffoldKey.currentState.showSnackBar(snackBar).closed.then((_) {
//         Navigator.pushReplacement(
//             context,
//             PageTransition(
//                 type: PageTransitionType.rightToLeft, child: OrderSuccess()));
//       });
//     } else {
//       final snackBar = SnackBar(
//           content: Text(response.message),
//           duration: new Duration(milliseconds: 15000));
//       _scaffoldKey.currentState.showSnackBar(snackBar).closed.then((_) {
//         // Navigator.pop(context);
//       });
//     }
//   }
