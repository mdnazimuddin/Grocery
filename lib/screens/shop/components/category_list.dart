import 'package:Uthbay/models/grocery.dart';
import 'package:Uthbay/models/grocery_list.dart';
import 'package:Uthbay/provider/grocery_provider.dart';
import 'package:Uthbay/screens/product/product_screen.dart';
import 'package:Uthbay/screens/widgets/build_app_bar.dart';
import 'package:Uthbay/screens/widgets/cart_notify.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  APIService apiService;
  GroceryList grocery;
  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    grocery = Provider.of<GroceryProvider>(context, listen: false).grocery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context,
        title: Text("All Category", style: TextStyle(color: Colors.white)),
        action: [cartNotify(context)],
      ),
      body: _categoriesList(),
    );
  }

  Widget _categoriesList() {
    return FutureBuilder(
      future: apiService.getGroceryCategories(grocery.href.link),
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
      // alignment: Alignment.centerLeft,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
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
            child: ListTile(
              contentPadding: EdgeInsets.all(8),
              leading: ClipOval(
                child: Image.network(
                  data.img,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(data.name),
              trailing: Icon(Icons.keyboard_arrow_right, size: 14),
            ),
          );
        },
      ),
    );
  }
}
