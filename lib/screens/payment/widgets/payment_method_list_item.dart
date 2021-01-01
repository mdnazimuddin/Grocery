import 'package:Uthbay/models/order.dart';
import 'package:Uthbay/models/payment_method.dart';
import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/screens/checkout/components/order_success.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class PaymentMethodListItem extends StatelessWidget {
  PaymentMethod paymentMethod;
  PaymentMethodListItem({this.paymentMethod});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () async {
        var cart = Provider.of<CartProvider>(context, listen: false);
        ProgressDialog dialog = new ProgressDialog(context);
        dialog.style(message: 'Please wait...');
        await dialog.show();
        cart.orderModel.payment = Payment();
        cart.orderModel.payment.paymentMethod = "Cash on Delivery";
        cart.orderModel.payment.paymentMethodTitle = 'Cash on Delivery';
        cart.orderModel.payment.setPaid = false;

        cart.orderModel.status = 'pending';
        await dialog.hide();
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: OrderSuccess()));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).focusColor.withOpacity(0.01),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).focusColor.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(0, 2))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                image: DecorationImage(
                  image: AssetImage(paymentMethod.logo),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          paymentMethod.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          paymentMethod.description,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Theme.of(context).focusColor,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
