import 'package:Uthbay/provider/grocery_provider.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

Widget favouriteGroceryIcon(BuildContext context, scaffoldKey) {
  return Consumer<GroceryProvider>(builder: (context, groceryProvider, child) {
    return groceryProvider.favouriteGrocery == true
        ? IconButton(
            icon: Icon(Icons.favorite),
            color: Colors.white,
            onPressed: () async {
              ProgressDialog dialog = new ProgressDialog(context);
              dialog.style(message: 'Please wait...');
              await dialog.show();
              groceryProvider
                  .deleteFavouriteGrocery(groceryProvider.grocery.id)
                  .then((ret) async {
                await dialog.hide();
                final snackBar = SnackBar(
                    content: Text("Remove Favourite Grocery."),
                    duration: new Duration(milliseconds: 1500));
                scaffoldKey.currentState.showSnackBar(snackBar);
              });
            },
          )
        : IconButton(
            icon: Icon(Icons.favorite_border),
            color: Colors.white,
            onPressed: () async {
              ProgressDialog dialog = new ProgressDialog(context);
              dialog.style(message: 'Please wait...');
              await dialog.show();

              groceryProvider
                  .addFavouriteGrocery(groceryProvider.grocery.id)
                  .then((ret) async {
                await dialog.hide();
                final snackBar = SnackBar(
                    content: Text("Addede Favourite Grocery."),
                    duration: new Duration(milliseconds: 1500));
                scaffoldKey.currentState.showSnackBar(snackBar);
              });
            },
          );
  });
}
