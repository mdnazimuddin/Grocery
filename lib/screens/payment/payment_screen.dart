import 'package:Uthbay/models/payment_method.dart';
import 'package:Uthbay/models/stripe_model.dart';
import 'package:Uthbay/provider/grocery_provider.dart';
import 'package:Uthbay/screens/checkout/checkout_base.dart';
import 'package:Uthbay/screens/payment/widgets/payment_card_action_list.dart';
import 'package:Uthbay/screens/payment/widgets/payment_method_list_item.dart';
import 'package:Uthbay/services/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends CheckoutBasePage {
  final String groceryId;
  PaymentScreen({this.groceryId});
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends CheckoutBasePageState<PaymentScreen> {
  PaymentMethod paymentMethod;
  PaymentMethodList list;

  @override
  initState() {
    super.initState();
    var provider = Provider.of<GroceryProvider>(context, listen: false);
    print(provider.grocery.name);
    provider.fetchPaymentSystem(provider.grocery.id);
    provider.fetchStripeAccount(provider.grocery.id).then((_) {
      var stripe = provider.stripeAccount;
      StripeService.init(
          publishableKey: stripe.publishableKey,
          secret: stripe.secret,
          merchantId: stripe.merchantId,
          androidPayMode: stripe.androidPayMode);
      print("Stripe Account ${stripe.secret}");
    });
  }

  @override
  Widget pageUI() {
    list = new PaymentMethodList();
    return Consumer<GroceryProvider>(
      builder: (context, model, child) {
        if (model.paymentSystem.groceryId != null) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Visibility(
                  visible: model.paymentSystem.stripe,
                  child: Column(
                    children: [
                      list.paymentsList.length > 0
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 0),
                                leading: Icon(
                                  Icons.payment,
                                  color: Theme.of(context).hintColor,
                                ),
                                title: Text(
                                  "Payment Options",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                subtitle:
                                    Text("Select you preffered payment Mode"),
                              ),
                            )
                          : SizedBox(height: 0),
                      SizedBox(height: 10),
                      paymentInfoList(context),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Visibility(
                  visible: model.paymentSystem.cod,
                  child: Column(
                    children: [
                      list.cashList.length > 0
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 0),
                                leading: Icon(
                                  Icons.monetization_on,
                                  color: Theme.of(context).hintColor,
                                ),
                                title: Text(
                                  "Cash on Delivery",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                subtitle:
                                    Text("Select you preffered payment Mode"),
                              ),
                            )
                          : SizedBox(height: 0),
                      SizedBox(height: 10),
                      ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          return PaymentMethodListItem(
                            paymentMethod: list.cashList.elementAt(index),
                          );
                        },
                        itemCount: list.cashList.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 10);
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget paymentInfoList(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Icon icon;
          String title;
          String description;
          switch (index) {
            case 0:
              icon = Icon(Icons.add_circle, color: Colors.black);
              title = "New Card";
              description = "Pay via new card";
              break;
            case 1:
              icon = Icon(Icons.credit_card, color: Colors.black);
              title = "Existing Card";
              description = "Pay via existing card";
              break;
          }

          return PaymentCardActionListItem(
            icon: icon,
            title: title,
            description: description,
            index: index,
          );
        },
        separatorBuilder: (context, index) => Divider(
              color: theme.primaryColor,
            ),
        itemCount: 2);
  }

  onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 0:
        // payViaNewCard(context);
        break;
      case 1:
        Navigator.pushNamed(context, '/existing-cards');
        break;
    }
  }

  // payViaNewCard(BuildContext context) async {
  //   ProgressDialog dialog = new ProgressDialog(context);
  //   dialog.style(
  //     message: 'Please wait...'
  //   );
  //   await dialog.show();
  //   var response = await StripeService.payWithNewCard(
  //     amount: '15000',
  //     currency: 'USD'
  //   );
  //   await dialog.hide();
  //   Scaffold.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(response.message),
  //       duration: new Duration(milliseconds: response.success == true ? 1200 : 3000),
  //     )
  //   );
  // }
}
