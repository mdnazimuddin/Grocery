import 'package:Uthbay/models/product.dart';
import 'package:Uthbay/provider/grocery_provider.dart';
import 'package:Uthbay/provider/products_provider.dart';
import 'package:Uthbay/screens/product/details/product_details.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  APIService apiService;
  List<Product> products;
  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    var grocery = Provider.of<GroceryProvider>(context, listen: false).grocery;
    Provider.of<ProductProvider>(context, listen: false)
        .fetchFavouriteGroceryProducts(grocery.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.allFavouriteProducts != null &&
              productProvider.totalFavouriteRecords > 0) {
            return productsUI(productProvider.allFavouriteProducts, context);
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
    );
  }

  Widget productsUI(List<Product> products, context) {
    return ListView.builder(
      itemCount: products.length,
      padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        Product product = products[index];
        return Card(
          elevation: 5.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: makeListTitle(context, product),
          ),
        );
      },
    );
  }

  Widget makeListTitle(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: ProductDetails(
                  product: product,
                )));
      },
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent.withOpacity(0.02),
          child: ClipOval(
            child: Image.network(
              product.images.length > 0
                  ? product.images[0].src
                  : "https://grocery.uthbay.com/images/no_img.png",
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
                product.name,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Visibility(
              visible: product.calculateDiscount() > 0,
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    '${product.calculateDiscount()}% OFF',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Visibility(
              visible: product.salePrice != product.regularPrice,
              child: Text(
                '\$${product.regularPrice}',
                style: TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              ' \$${product.salePrice}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  Widget shimmerProductList() {
    return ListView.builder(
      itemCount: 8,
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
            width: 48.0,
            height: 10.0,
            color: Colors.black12,
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.black12),
        );
      },
    );
  }
}
