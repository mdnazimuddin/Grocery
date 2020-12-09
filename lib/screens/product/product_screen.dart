import 'package:Uthbay/models/product.dart';
import 'package:Uthbay/screens/base/base_screen.dart';
import 'package:Uthbay/screens/product/widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductScreen extends BaseScreen {
  int categoryId;
  ProductScreen({this.categoryId});
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends BaseScreenState<ProductScreen> {
  @override
  Widget pageUI() {
    Product product = new Product();

    return Container(
      child: ProductCard(data: product),
    );
  }
}
