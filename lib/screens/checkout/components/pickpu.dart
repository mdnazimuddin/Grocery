import 'package:Uthbay/models/customer_details.dart';
import 'package:Uthbay/models/customer_details_model.dart';
import 'package:Uthbay/models/pickup_model.dart';
import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/screens/checkout/checkout_base.dart';
import 'package:Uthbay/screens/checkout/components/verify_address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickupPage extends CheckoutBasePage {
  final String groceryId;
  PickupPage({this.groceryId});
  @override
  _PickupPageState createState() => _PickupPageState();
}

class _PickupPageState extends CheckoutBasePageState<PickupPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentPage = 0;
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.fetchPickup();
  }

  @override
  Widget pageUI() {
    return Consumer<CartProvider>(
      builder: (context, customerModel, child) {
        if (customerModel.pickupModel.groceryId != null) {
          return pickpuUI(customerModel.pickupModel);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget pickpuUI(PickupModel pickup) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Visibility(
            visible: pickup.onlineOrder,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => VerifyAddress()));
                },
                child: Card(
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Image.asset('assets/images/delivery.png'),
                      title: Text(
                        "Online Order",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      subtitle: Text(
                          "We deliver your groceries in fast home delivery."),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: pickup.selfPickup,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: InkWell(
                onTap: () {},
                child: Card(
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Image.asset('assets/images/selfpickup.png'),
                      title: Text(
                        "Self-Pickup",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      subtitle: Text(
                          "you need to collect products from the grocery shop"),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
