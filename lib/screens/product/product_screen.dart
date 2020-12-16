import 'dart:async';

import 'package:Uthbay/models/product.dart';
import 'package:Uthbay/provider/products_provider.dart';
import 'package:Uthbay/screens/base/base_screen.dart';
import 'package:Uthbay/screens/product/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends BaseScreen {
  int categoryId;
  int tagId;
  String title;
  ProductScreen({this.categoryId, this.tagId, title});
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends BaseScreenState<ProductScreen> {
  int _page = 1;
  ScrollController _scrollController = new ScrollController();
  final _searchQuery = new TextEditingController();
  Timer _debounce;
  final _sortByOptions = {
    SortBy("id", "Populartity", "asc"),
    SortBy("updated_at", "Latest", "asc"),
    SortBy("price", "Price: High to Low", "desc"),
    SortBy("price", "Price: Low to High", "asc"),
  };
  initState() {
    print(widget.tagId);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var productList = Provider.of<ProductProvider>(context, listen: false);
      productList.resetStreams();
      productList.setLoadingState(LoadMoreStatus.INITIAL);
      productList.fetchProducts(_page,
          categoryId: widget.categoryId.toString(),
          tagId: widget.tagId.toString());
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          productList.setLoadingState(LoadMoreStatus.LOADING);

          productList.fetchProducts(++_page,
              categoryId: widget.categoryId.toString(),
              tagId: widget.tagId.toString());
        }
      });
    });

    // _searchQuery.addListener(_onSearchChang);
  }

  _onSearchChang() {
    var productList = Provider.of<ProductProvider>(context, listen: false);
    if (_debounce?.isActive ?? false) _debounce.cancel();

    // _debounce = Timer(const Duration(milliseconds: 1000), () {
    //   productList.resetStreams();
    //   productList.setLoadingState(LoadMoreStatus.INITIAL);
    //   productList.fetchProducts(_page,
    //       strSerach: _searchQuery.text,
    //       categoryId: widget.categoryId.toString());
    // });
    productList.resetStreams();
    productList.setLoadingState(LoadMoreStatus.INITIAL);
    productList.fetchProducts(_page,
        strSerach: _searchQuery.text,
        categoryId: widget.categoryId.toString(),
        tagId: widget.tagId.toString());
  }

  @override
  Widget pageUI() {
    return _productsList();
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
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.amber),
          ));
        }
      },
    );
  }

  Widget _buildList(List<Product> items, bool isLoadMore) {
    return Column(
      children: [
        _productFilters(),
        Flexible(
          child: GridView.count(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            controller: _scrollController,
            crossAxisCount: 2,
            scrollDirection: Axis.vertical,
            children: items.map((Product item) {
              return ProductCard(data: item);
            }).toList(),
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
    ;
  }

  Widget _productFilters() {
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
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Color(0xffe6e6ec),
                filled: true,
              ),
            ),
          ),
          SizedBox(width: 15),
          Container(
            decoration: BoxDecoration(
              color: Color(0xffe6e6ec),
              borderRadius: BorderRadius.circular(9.0),
            ),
            child: PopupMenuButton(
              onSelected: (sortBy) {
                var productList =
                    Provider.of<ProductProvider>(context, listen: false);
                productList.resetStreams();
                productList.setSortOrder(sortBy);
                productList.fetchProducts(_page,
                    categoryId: widget.categoryId.toString(),
                    tagId: widget.tagId.toString());
              },
              itemBuilder: (BuildContext context) {
                return _sortByOptions.map((item) {
                  return PopupMenuItem(
                    value: item,
                    child: Container(
                      child: Text(item.text),
                    ),
                  );
                }).toList();
              },
              icon: Icon(Icons.tune),
            ),
          )
        ],
      ),
    );
  }
}
