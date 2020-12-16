import 'package:Uthbay/models/cart_request_model.dart';
import 'package:Uthbay/models/product.dart';
import 'package:Uthbay/models/variable_product.dart';
import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/provider/loader_provider.dart';
import 'package:Uthbay/screens/product/widgets/related_products.dart';
import 'package:Uthbay/utilis/custom_stepper.dart';
import 'package:Uthbay/utilis/expand_text.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class ProductDetailsWidget extends StatelessWidget {
  Product data;
  List<VariableProduct> variableProducts;
  ProductDetailsWidget({this.data, this.variableProducts});
  int qty = 0;

  CartProducts cartProducts = new CartProducts();
  final CarouselController _carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    print("Variable Product: ${this.variableProducts[0].id}");
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _productImages(data.images, context),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: data.calculateDiscount() > 0,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(color: Colors.green),
                      child: Text(
                        '${data.calculateDiscount()}% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  data.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: data.type != "variable",
                      child: Text(
                        data.attributes != null && data.attributes.length > 0
                            ? (data.attributes[0].option +
                                " " +
                                data.attributes[0].name)
                            : "",
                      ),
                    ),
                    Visibility(
                      visible: data.type == "variable",
                      child: selectDropdown(context, "", this.variableProducts,
                          (VariableProduct value) {
                        print(value.salePrice);
                        this.data.salePrice = value.salePrice;
                        this.data.variableProduct = value;
                      }),
                    ),
                    Text(' \$${data.salePrice}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold))
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomStepper(
                      lowerLimit: 0,
                      upperLimit: 50,
                      stepValue: 1,
                      iconSize: 22.0,
                      value: this.qty,
                      onChange: (value) {
                        cartProducts.quantity = value;
                        Provider.of<CartProvider>(context, listen: false)
                            .updateQty(int.parse(data.id), value);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Add To Cart",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (cartProducts.quantity != null) {
                          Provider.of<LoaderProvider>(context, listen: false)
                              .setLoadingStatus(true);
                          print(int.parse(data.groceryID));
                          var cartProvider =
                              Provider.of<CartProvider>(context, listen: false);
                          cartProducts.productId = int.parse(data.id);
                          cartProducts.variationId =
                              data.variableProduct != null
                                  ? int.parse(data.variableProduct.id)
                                  : 0;
                          print("Var: ${cartProducts.variationId}");
                          cartProvider.addToCart(
                            int.parse(data.groceryID),
                            cartProducts,
                            (val) {
                              Provider.of<LoaderProvider>(context,
                                      listen: false)
                                  .setLoadingStatus(false);
                              print(val);
                            },
                          );
                        }
                      },
                      color: Colors.redAccent,
                      padding: EdgeInsets.all(14),
                      shape: StadiumBorder(),
                    )
                  ],
                ),
                SizedBox(height: 5),
                ExpandText(
                  labelHeader: "Product Details",
                  shortDesc: data.sortDescription,
                  desc: data.description,
                ),
                Divider(),
                SizedBox(height: 10),
                Visibility(
                  visible: this.data.relatedIds.length != 0,
                  child: RelatedProducts(
                      labelName: "Related Products",
                      products: this.data.relatedIds),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _productImages(List<ProductImage> images, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 250,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: new CarouselSlider.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Center(
                      child: Image.network(
                        images[index].src,
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                  aspectRatio: 1.0,
                ),
                carouselController: _carouselController),
          ),
          Positioned(
            top: 100,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                _carouselController.previousPage();
              },
            ),
          ),
          Positioned(
            top: 100,
            left: MediaQuery.of(context).size.width - 80,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                _carouselController.nextPage();
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget selectDropdown(
    BuildContext context,
    Object initialValue,
    dynamic data,
    Function onChange, {
    Function onValidate,
  }) {
    print("data:${data[0].attributes.first.option}");
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: 75,
        width: 100,
        padding: EdgeInsets.only(top: 5),
        child: new DropdownButtonFormField<VariableProduct>(
          hint: new Text("Select"),
          value: data != null ? data[0] : null,
          isDense: true,
          decoration: fieldDecoration(context, "", ""),
          onChanged: (VariableProduct newValue) {
            FocusScope.of(context).requestFocus(new FocusNode());
            onChange(newValue);
          },
          items: data != null
              ? data.map<DropdownMenuItem<VariableProduct>>(
                  (VariableProduct data) {
                  return DropdownMenuItem<VariableProduct>(
                    value: data,
                    child: new Text(
                      data.attributes.first.option +
                          " " +
                          data.attributes.first.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList()
              : null,
        ),
      ),
    );
  }

  static InputDecoration fieldDecoration(
    BuildContext contex,
    String hintText,
    String helperText, {
    Widget prefixIcon,
    Widget suffixIcon,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(6),
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(contex).primaryColor,
          width: 1,
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(contex).primaryColor,
          width: 1,
        ),
      ),
    );
  }
}
