import 'package:Uthbay/models/grocery.dart';
import 'package:Uthbay/models/tag.dart';
import 'package:Uthbay/screens/shop/widgets/shop_categories.dart';
import 'package:Uthbay/screens/shop/widgets/shop_product.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  final String url;
  DashboardScreen(this.url);
  @override
  _DashboardScreenState createState() => _DashboardScreenState(this.url);
}

class _DashboardScreenState extends State<DashboardScreen> {
  final String url;
  _DashboardScreenState(this.url);
  APIService apiService;
  Grocery grocery;
  getGrocery() async {
    apiService.getGrocery(url).then((data) => {
          setState(() {
            grocery = data;
            print(grocery);
          })
        });
  }

  _onLayoutDone(_) {
    getGrocery();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    super.initState();
    apiService = new APIService();
    print(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            imageCarousel(context),
            WidgetCategory(this.url),
            _tagList(context)
          ],
        ),
      ),
    );
  }

  Widget imageCarousel(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: 200.0,
      child: FutureBuilder<Object>(
          future: apiService.getGroceryImages(url),
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
      future: apiService.getTags(this.url),
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
