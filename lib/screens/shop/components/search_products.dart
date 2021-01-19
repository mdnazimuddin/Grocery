import 'dart:async';
import 'dart:ui';

import 'package:Uthbay/models/product.dart';
import 'package:Uthbay/provider/grocery_provider.dart';
import 'package:Uthbay/provider/products_provider.dart';
import 'package:Uthbay/screens/product/details/product_details.dart';
import 'package:Uthbay/screens/widgets/build_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SearchProducts extends StatefulWidget {
  @override
  _SearchProductsState createState() => _SearchProductsState();
}

class _SearchProductsState extends State<SearchProducts> {
  int _page = 1;
  ScrollController _scrollController = new ScrollController();
  final _searchQuery = new TextEditingController();
  Timer _debounce;
  _onSearchChang() {
    var productList = Provider.of<ProductProvider>(context, listen: false);
    var grocery = Provider.of<GroceryProvider>(context, listen: false).grocery;
    if (_debounce?.isActive ?? false) _debounce.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      productList.resetStreams();
      productList.setLoadingState(LoadMoreStatus.INITIAL);
      productList.fetchProducts(_page,
          strSerach: _searchQuery.text,
          groceryId: grocery.id,
          categoryId: null,
          tagId: null);
    });
    // productList.resetStreams();
    // productList.setLoadingState(LoadMoreStatus.INITIAL);
    // productList.fetchProducts(_page,
    //     strSerach: _searchQuery.text,
    //     groceryId: grocery.id,
    //     categoryId: null,
    //     tagId: null);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.red));
    return Scaffold(
      appBar: buildAppBar(
        context,
        title: Text(
          "Search",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          _productSearch(),
          Flexible(child: _productsList()),
        ],
      ),
    );
  }

  Widget _productSearch() {
    return Container(
      height: 51,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _searchQuery,
              onSubmitted: (value) {
                this._onSearchChang();
              },
              onChanged: (value) {
                this._onSearchChang();
              },
              autofocus: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search Product",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Color(0xffe6e6ec),
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productsList() {
    return new Consumer<ProductProvider>(
      builder: (BuildContext context, productModel, child) {
        if (productModel.allProducts != null &&
            productModel.allProducts.length > 0 &&
            productModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL)
          return _buildList(
            productModel.allProducts,
            productModel.getLoadMoreStatus() == LoadMoreStatus.LOADING,
          );
        else {
          return Shimmer.fromColors(
            baseColor: Colors.grey[900],
            highlightColor: Colors.grey[200],
            enabled: true,
            child: shimmerProductList(),
          );
        }
      },
    );
  }

  Widget _buildList(List<Product> items, bool isLoadMore) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              Product product = items[index];
              return makeListTitle(product);
            },
          ),
        ),
        Visibility(
          child: Container(
            padding: EdgeInsets.all(10),
            height: 35.0,
            width: 35.0,
            child: CircularProgressIndicator(),
          ),
          visible: isLoadMore,
        )
      ],
    );
  }

  Widget makeListTitle(Product product) {
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
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
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
