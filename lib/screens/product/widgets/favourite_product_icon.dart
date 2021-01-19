import 'package:Uthbay/provider/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

Widget favouriteProductIcon(BuildContext context, scaffoldKey,
    {String groceryId, String productId}) {
  return Consumer<ProductProvider>(builder: (context, productProvider, child) {
    return productProvider.favouriteProduct == true
        ? IconButton(
            icon: Icon(Icons.favorite),
            color: Colors.redAccent,
            onPressed: () async {
              ProgressDialog dialog = new ProgressDialog(context);
              dialog.style(message: 'Please wait...');
              await dialog.show();
              productProvider
                  .deleteFavouriteGroceryProduct(groceryId, productId)
                  .then((ret) async {
                await dialog.hide();
                final snackBar = SnackBar(
                    content: Text("Remove Favourite Grocery Product."),
                    duration: new Duration(milliseconds: 1500));
                scaffoldKey.currentState.showSnackBar(snackBar);
              });
            },
          )
        : IconButton(
            icon: Icon(Icons.favorite_border),
            color: Colors.grey,
            onPressed: () async {
              ProgressDialog dialog = new ProgressDialog(context);
              dialog.style(message: 'Please wait...');
              await dialog.show();

              productProvider
                  .addFavouriteGroceryProduct(groceryId, productId)
                  .then((ret) async {
                await dialog.hide();
                final snackBar = SnackBar(
                    content: Text("Addede Favourite Grocery Product."),
                    duration: new Duration(milliseconds: 1500));
                scaffoldKey.currentState.showSnackBar(snackBar);
              });
            },
          );
  });
}
