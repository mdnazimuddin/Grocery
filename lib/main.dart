import 'dart:ui';

import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/provider/loader_provider.dart';
import 'package:Uthbay/provider/products_provider.dart';
import 'package:Uthbay/screens/base/base_screen.dart';
import 'package:Uthbay/screens/product/cart/cart_page.dart';
import 'package:Uthbay/screens/product/details/product_details.dart';
import 'package:Uthbay/screens/product/product_screen.dart';
import 'package:Uthbay/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
          child: ProductScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoaderProvider(),
          child: BaseScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: BaseScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: ProductDetails(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: CartPage(),
        )
      ],
      child: MaterialApp(
        title: 'Uthbay Go',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: Colors.white,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            elevation: 0,
            foregroundColor: Colors.white,
          ),
          accentColor: Colors.redAccent,
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 22.0, color: Colors.redAccent),
            headline2: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: Colors.redAccent,
            ),
            bodyText1: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Colors.blueAccent),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
