import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  String categoryId;
  ProductScreen({this.categoryId});
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('product'),
    );
  }
}
