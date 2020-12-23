import 'dart:ui';

import 'package:Uthbay/models/customer_details.dart';
import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/screens/checkout/checkout_base.dart';
import 'package:Uthbay/screens/checkout/components/checkout_order.dart';
import 'package:Uthbay/utilis/form_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyPhone extends CheckoutBasePage {
  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends CheckoutBasePageState<VerifyPhone> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentPage = 0;
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.fetchShippingDetails();
  }

  @override
  Widget pageUI() {
    return Consumer<CartProvider>(
      builder: (context, customerModel, child) {
        if (customerModel.customerDetailsModel.id != null) {
          return new Form(
            key: globalKey,
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
                SizedBox(height: 15),
                FormHelper.fieldLabel("Phone"),
                FormHelper.textInput(
                    context, model.phone, (value) => {model.phone = value},
                    onValidate: (value) {
                  if (value.toString().isEmpty) {
                    return 'Plesae enter Mobile Number.';
                  }
                  return null;
                }, hintText: "Enter Phone Number"),
                SizedBox(height: 20),
                Center(
                  child: FormHelper.saveButton(
                    "NEXT",
                    () {
                      if (validetAndSave()) {
                        var cartProvider =
                            Provider.of<CartProvider>(context, listen: false);
                        cartProvider.setShippingMobile(model.phone);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckoutOrder()));
                      }
                    },
                    fullWidth: true,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validetAndSave() {
    final form = globalKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
