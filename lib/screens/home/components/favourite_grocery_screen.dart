import 'package:Uthbay/models/grocery_list.dart';
import 'package:Uthbay/models/product.dart';
import 'package:Uthbay/provider/grocery_provider.dart';
import 'package:Uthbay/provider/products_provider.dart';
import 'package:Uthbay/screens/product/details/product_details.dart';
import 'package:Uthbay/screens/shop/shop_screen.dart';
import 'package:Uthbay/screens/widgets/build_app_bar.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class FavoriteGroceryScreen extends StatefulWidget {
  @override
  _FavoriteGroceryScreenState createState() => _FavoriteGroceryScreenState();
}

class _FavoriteGroceryScreenState extends State<FavoriteGroceryScreen> {
  APIService apiService;
  List<Product> products;
  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    var grocery = Provider.of<GroceryProvider>(context, listen: false)
        .fetchFavouriteGrocery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context,
        title: Text(
          "Favourite Grocery",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: new Consumer<GroceryProvider>(
          builder: (context, groceryProvider, child) {
            if (groceryProvider.allFavouriteGrocery != null &&
                groceryProvider.totalFavouriteRecords > 0) {
              return groceriesUI(groceryProvider.allFavouriteGrocery, context);
            } else {
              return Shimmer.fromColors(
                baseColor: Colors.grey[900],
                highlightColor: Colors.grey[200],
                enabled: true,
                child: shimmerProductList(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget groceriesUI(List<GroceryList> groceries, context) {
    return ListView.builder(
      itemCount: groceries.length,
      padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        GroceryList grocery = groceries[index];
        return Card(
          elevation: 5.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: makeListTitle(context, grocery),
          ),
        );
      },
    );
  }

  Widget makeListTitle(BuildContext context, GroceryList grocery) {
    print(grocery.logo);
    return GestureDetector(
      onTap: () {
        Provider.of<GroceryProvider>(context, listen: false)
            .setGrocery(grocery);
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: ShopScreen(
                  grocery: grocery,
                )));
      },
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent.withOpacity(0.02),
          child: ClipOval(
            child: Image.network(
              grocery.logo ?? 'https://grocery.uthbay.com/images/no_img.png',
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                grocery.name,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Visibility(
              visible: grocery.claimed,
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 15,
                    height: 15,
                    child: Image.asset("assets/images/varifacy_icon.png"),
                  ),
                ),
              ),
            )
          ],
        ),
        subtitle: Text(
          "${grocery.address.address_1}, ${grocery.address.city}, ${grocery.address.state}",
          maxLines: 2,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 13,
          ),
        ),
        trailing: Text(
          grocery.opening_status ? 'Opened' : 'Closed',
          style: TextStyle(
            color: grocery.opening_status ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget shimmerProductList() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (_, __) {
        return ListTile(
          // contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent.withOpacity(0.02),
            child: ClipOval(
              child: Container(
                width: 148.0,
                height: 148.0,
                color: Colors.black12,
              ),
            ),
          ),
          title: Container(
            width: 48.0,
            height: 10.0,
            color: Colors.black12,
          ),
          subtitle: Container(
            width: 10.0,
            height: 10.0,
            color: Colors.black12,
          ),
          trailing: Container(
            width: 30.0,
            height: 10.0,
            color: Colors.black12,
          ),
        );
      },
    );
  }
}
