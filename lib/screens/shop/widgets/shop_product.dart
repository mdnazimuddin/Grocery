import 'package:Uthbay/models/product.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:flutter/material.dart';

class WidgetShopProducts extends StatefulWidget {
  String labelName;
  String tagId;
  WidgetShopProducts({this.labelName, this.tagId});
  @override
  _WidgetShopProductsState createState() => _WidgetShopProductsState();
}

class _WidgetShopProductsState extends State<WidgetShopProducts> {
  APIService apiService;

  @override
  void initState() {
    super.initState();
    apiService = new APIService();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF4F7FA),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, top: 4),
                child: Text(
                  this.widget.labelName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, top: 4),
                child: FlatButton(
                  child: Text(
                    'View All',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          _productsList()
        ],
      ),
    );
  }

  Widget _productsList() {
    return FutureBuilder(
      future: apiService.getProducts(tagId: this.widget.tagId),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData)
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.amber),
          ));
        else {
          List<Product> products = snapshot.data;
          return _buildCategory(products);
        }
      },
    );
  }

  Widget _buildCategory(List<Product> items) {
    return Container(
      height: 200,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          var data = items[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                width: 130,
                height: 120,
                alignment: Alignment.center,
                child: Image.network(
                  data.images[0].src,
                  height: 120,
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 5),
                        blurRadius: 15,
                      )
                    ]),
              ),
              Container(
                width: 130,
                alignment: Alignment.centerLeft,
                child: Text(
                  data.name,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                width: 130,
                margin: EdgeInsets.only(top: 4, left: 4),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      '\$ ${data.regularPrice}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.redAccent,
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$ ${data.salePrice}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
