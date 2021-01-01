import 'package:Uthbay/models/grocery.dart';
import 'package:Uthbay/models/grocery_list.dart';
import 'package:Uthbay/models/tag.dart';
import 'package:Uthbay/provider/grocery_provider.dart';
import 'package:Uthbay/screens/shop/widgets/shop_categories.dart';
import 'package:Uthbay/screens/shop/widgets/shop_product.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  final GroceryList grocery;
  DashboardScreen({@required this.grocery});
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  _DashboardScreenState();
  APIService apiService;
  GroceryList grocery;
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    super.initState();
    apiService = new APIService();
    setState(() {
      grocery = Provider.of<GroceryProvider>(context, listen: false).grocery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            imageCarousel(context),
            WidgetCategory(grocery.href.link),
            _tagList(context)
          ],
        ),
      ),
    );
  }

  Widget imageCarousel(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: 220.0,
      child: FutureBuilder<Object>(
          future: apiService.getGroceryImages(grocery.href.link),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.amber),
              ));
            else {
              List<SliderImages> images = snapshot.data;
              return CarouselSlider.builder(
                  unlimitedMode: true,
                  // autoSliderTimeout: Duration(seconds: 1),
                  enableAutoSlider: true,
                  autoSliderTransitionTime: Duration(microseconds: 600),
                  slideBuilder: (index) {
                    SliderImages img = images[index];
                    return FittedBox(
                        fit: BoxFit.fill, child: Image.network(img.src));
                  },
                  slideTransform: CubeTransform(),
                  slideIndicator: CircularSlideIndicator(
                    indicatorBackgroundColor: Colors.white,
                    currentIndicatorColor: Theme.of(context).accentColor,
                    padding: EdgeInsets.only(bottom: 24),
                  ),
                  itemCount: images.length);
            }
          }),
    );
  }

  Widget _tagList(BuildContext context) {
    return FutureBuilder(
      future: apiService.getTags(this.grocery.href.link),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData)
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.amber),
          ));
        else {
          List tags = snapshot.data;
          return _buildTag(tags);
        }
      },
    );
  }

  Widget _buildTag(List tags) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: tags.length,
      itemBuilder: (context, index) {
        var data = tags[index];
        return WidgetShopProducts(
          labelName: data['name'],
          tagId: data['id'].toString(),
        );
      },
    );
  }
}
