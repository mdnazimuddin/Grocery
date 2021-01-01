import 'package:Uthbay/models/cart_response_model.dart';
import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/provider/loader_provider.dart';
import 'package:Uthbay/utilis/custom_stepper.dart';
import 'package:Uthbay/utilis/show_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatelessWidget {
  final String groceryId;
  CartItem data;
  CartProduct({this.data, this.groceryId});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: makeListTitle(context),
      ),
    );
  }

  ListTile makeListTitle(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      leading: Container(
        width: 50,
        height: 150,
        alignment: Alignment.center,
        child: Image.network(data.thumbnail, height: 150),
      ),
      title: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          data.variationId == 0
              ? data.productName
              : "${data.productName} (${data.attributeValue} ${data.attribute})",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.all(5),
        child: Wrap(
          direction: Axis.vertical,
          children: [
            Text(
              "\$${data.productSalePrice.toString()}",
              style: TextStyle(color: Colors.black),
            ),
            FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 20,
                  ),
                  Text(
                    "Remove",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              onPressed: () {
                AlertMessage.showMessage(
                  context,
                  "Uthbay Grocery",
                  "Delete item?",
                  "Delete",
                  () {
                    Provider.of<LoaderProvider>(context, listen: false)
                        .setLoadingStatus(true);
                    Provider.of<CartProvider>(context, listen: false)
                        .removeItem(data.productId,
                            groceryId: int.parse(groceryId),
                            variationId: data.variationId);
                    Provider.of<LoaderProvider>(context, listen: false)
                        .setLoadingStatus(false);
                    Navigator.of(context).pop();
                  },
                  buttonText2: "Cancel",
                  isConfirmationDialog: true,
                  onPressed2: () {
                    Navigator.of(context).pop();
                  },
                );
              },
              padding: EdgeInsets.all(8),
              color: Colors.redAccent,
              shape: StadiumBorder(),
            ),
          ],
        ),
      ),
      trailing: Container(
        width: 120,
        child: CustomStepper(
          iconSize: 22.0,
          lowerLimit: 1,
          upperLimit: 1000,
          stepValue: 1,
          value: data.qty,
          onChange: (value) {
            Provider.of<CartProvider>(context, listen: false).updateQty(
                data.productId, value,
                variationId: data.variationId);
            Provider.of<LoaderProvider>(context, listen: false)
                .setLoadingStatus(true);
            var cartProvider =
                Provider.of<CartProvider>(context, listen: false);
            cartProvider.updateCart(
              int.parse(groceryId),
              (val) {
                Provider.of<LoaderProvider>(context, listen: false)
                    .setLoadingStatus(false);
                print(val);
              },
            );
          },
        ),
      ),
    );
  }
}
