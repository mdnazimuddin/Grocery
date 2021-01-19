import 'package:Uthbay/models/grocery.dart';
import 'package:Uthbay/screens/product/product_screen.dart';
import 'package:Uthbay/screens/shop/components/category_list.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class WidgetCategory extends StatefulWidget {
  final String url;
  WidgetCategory(this.url);
  @override
  _WidgetCategoryState createState() => _WidgetCategoryState(this.url);
}

class _WidgetCategoryState extends State<WidgetCategory> {
  final String url;
  _WidgetCategoryState(this.url);
  APIService apiService;
  @override
  void initState() {
    super.initState();
    apiService = new APIService();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, top: 5),
                child: Text(
                  'All Categories',
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
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: CategoryList()));
                  },
                ),
              ),
            ],
          ),
          _categoriesList()
        ],
      ),
    );
  }

  Widget _categoriesList() {
    return FutureBuilder(
      future: apiService.getGroceryCategories(url),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData)
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.amber),
          ));
        else {
          List<Category> categories = snapshot.data;
          return _buildCategory(categories);
        }
      },
    );
  }

  Widget _buildCategory(List<Category> categories) {
    return Container(
      height: 150,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          var data = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProductScreen(categoryId: data.id)));
            },
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  child: ClipOval(
                    child: Image.network(
                      data.img,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(data.name),
                    Icon(Icons.keyboard_arrow_right, size: 14)
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
