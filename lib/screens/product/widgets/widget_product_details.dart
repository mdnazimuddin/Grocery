import 'dart:ui';

import 'package:Uthbay/models/product.dart';
import 'package:Uthbay/screens/product/widgets/related_products.dart';
import 'package:Uthbay/utilis/custom_stepper.dart';
import 'package:Uthbay/utilis/expand_text.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geolocator/geolocator.dart';

class ProductDetailsWidget extends StatelessWidget {
  Product data;
  ProductDetailsWidget({this.data});
  int qty = 0;
  final CarouselController _carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
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
                    Text(
                      data.attributes != null && data.attributes.length > 0
                          ? (data.attributes[0].options.join("-").toString() +
                              "" +
                              data.attributes[0].name)
                          : "",
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
                        print(value);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Add To Cart",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
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
                RelatedProducts(
                    labelName: "Related Products",
                    products: this.data.relatedIds)
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
}
