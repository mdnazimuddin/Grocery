import 'package:Uthbay/models/order.dart';
import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/screens/checkout/components/order_success.dart';
import 'package:Uthbay/services/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ExistingCardsPage extends StatefulWidget {
  ExistingCardsPage({Key key}) : super(key: key);

  @override
  ExistingCardsPageState createState() => ExistingCardsPageState();
}

class ExistingCardsPageState extends State<ExistingCardsPage> {
  List cards = [
    {
      'cardNumber': '4242424242424242',
      'expiryDate': '04/24',
      'cardHolderName': 'Muhammad Ahsan Ayaz',
      'cvvCode': '424',
      'showBackView': false,
    },
    {
      'cardNumber': '5555552500001001',
      'expiryDate': '04/23',
      'cardHolderName': 'Tracer',
      'cvvCode': '123',
      'showBackView': false,
    }
  ];

  payViaExistingCard(BuildContext context, card) async {
    var cart = Provider.of<CartProvider>(context, listen: false);
    String total =
        ((double.parse(cart.orderModel.totalAmount) * 100).toInt()).toString();
    print(total);
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
    await dialog.hide();
    if (response.success) {
      cart.orderModel.payment = Payment();
      cart.orderModel.payment.paymentMethod = response.brand;
      cart.orderModel.payment.paymentMethodTitle = 'Stripe';
      cart.orderModel.payment.setPaid = true;
      cart.orderModel.payment.transactionId = response.transactionId;

      cart.orderModel.status = 'pending';

      Scaffold.of(context)
          .showSnackBar(SnackBar(
            content: Text(response.message),
            duration: new Duration(milliseconds: 800),
          ))
          .closed
          .then((_) {
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: OrderSuccess()));
      });
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(
            content: Text(response.message),
            duration: new Duration(milliseconds: 1200),
          ))
          .closed
          .then((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose existing card'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (BuildContext context, int index) {
            var card = cards[index];
            return InkWell(
              onTap: () {
                payViaExistingCard(context, card);
              },
              child: CreditCardWidget(
                cardNumber: card['cardNumber'],
                expiryDate: card['expiryDate'],
                cardHolderName: card['cardHolderName'],
                cvvCode: card['cvvCode'],
                showBackView: false,
              ),
            );
          },
        ),
      ),
    );
  }
}
