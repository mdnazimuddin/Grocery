import 'package:Uthbay/models/product.dart';
import 'package:Uthbay/screens/base/base_screen.dart';
import 'package:Uthbay/screens/product/widgets/widget_product_details.dart';
import 'package:flutter/material.dart';

class ProductDetails extends BaseScreen {
  Product product;
  ProductDetails({this.product});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends BaseScreenState<ProductDetails> {
  @override
  Widget pageUI() {
    return Container(
      child: ProductDetailsWidget(data: widget.product),
    );
  }
}
