import 'package:Uthbay/models/product.dart';
import 'package:Uthbay/models/variable_product.dart';
import 'package:Uthbay/provider/products_provider.dart';
import 'package:Uthbay/screens/base/base_screen.dart';
import 'package:Uthbay/screens/product/widgets/widget_product_details.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetails extends BaseScreen {
  Product product;
  ProductDetails({this.product});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends BaseScreenState<ProductDetails> {
  APIService apiService;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scaffoldKey = super.scaffoldKey;
    var productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.favouriteGroceryProductStatus(
        widget.product.groceryID, widget.product.id);
  }

  @override
  Widget pageUI() {
    return Container(
      child: this.widget.product.type.toString() == "variable"
          ? _variableProductList()
          : ProductDetailsWidget(
              data: widget.product, scaffoldKey: _scaffoldKey),
    );
  }

  Widget _variableProductList() {
    apiService = new APIService();
    return new FutureBuilder(
      future: apiService.getVariableProducts(productId: this.widget.product.id),
      builder:
          (BuildContext context, AsyncSnapshot<List<VariableProduct>> model) {
        if (model.hasData) {
          return ProductDetailsWidget(
            data: this.widget.product,
            variableProducts: model.data,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
