import 'dart:ui';

import 'package:Uthbay/models/customer_details.dart';
import 'package:Uthbay/models/customer_details_model.dart';
import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/screens/checkout/checkout_base.dart';
import 'package:Uthbay/screens/checkout/components/verify_phone.dart';
import 'package:Uthbay/screens/payment/payment_screen.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:Uthbay/utilis/form_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyAddress extends CheckoutBasePage {
  @override
  _VerifyAddressState createState() => _VerifyAddressState();
}

class _VerifyAddressState extends CheckoutBasePageState<VerifyAddress> {
  GlobalKey<FormState> _globalKey;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _globalKey = GlobalKey<FormState>();
    currentPage = 0;
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.fetchShippingDetails();
  }

  @override
  Widget pageUI() {
    return Consumer<CartProvider>(
      builder: (context, customerModel, child) {
        if (customerModel.customerDetailsModel.id != null) {
          _globalKey = GlobalKey<FormState>();
          return new Form(
            key: _globalKey,
            child: _formUI(customerModel.customerDetailsModel),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _formUI(CustomerDetails model) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Shipping Address",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                Divider(),
                FormHelper.fieldLabel("Address"),
                FormHelper.textInput(
                  context,
                  model.shipping.address1,
                  (value) => {model.shipping.address1 = value},
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Plesae enter Address.';
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("Apartment, suite, etc"),
                FormHelper.textInput(
                  context,
                  model.shipping.address2,
                  (value) => {model.shipping.address2 = value},
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("Country"),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("State"),
                    )
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: FormHelper.fieldLabelValue(
                            context, model.shipping.country),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FormHelper.fieldLabelValue(
                            context, model.shipping.state),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("City"),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("Postcode"),
                    )
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: FormHelper.fieldLabelValue(
                            context, model.shipping.city),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FormHelper.fieldLabelValue(
                            context, model.shipping.postcode),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: FormHelper.saveButton("NEXT", () {
                    var cartProvider =
                        Provider.of<CartProvider>(context, listen: false);
                    cartProvider.setShippingAddress(model.shipping);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => VerifyPhone()));
                  }, fullWidth: true),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validetAndSave() {
    if (_globalKey.currentState.validate()) {
      // globalKey.currentState.save();
      return true;
    }
    print("Test");
    return false;
  }
}
