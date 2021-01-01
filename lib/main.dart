import 'dart:ui';

import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/provider/customer_provider.dart';
import 'package:Uthbay/provider/grocery_provider.dart';
import 'package:Uthbay/provider/loader_provider.dart';
import 'package:Uthbay/provider/order_provider.dart';
import 'package:Uthbay/provider/products_provider.dart';
import 'package:Uthbay/screens/base/base_screen.dart';
import 'package:Uthbay/screens/checkout/components/pickpu.dart';
import 'package:Uthbay/screens/home/home_screen.dart';
import 'package:Uthbay/screens/order/components/order_details.dart';
import 'package:Uthbay/screens/order/orders_page.dart';
import 'package:Uthbay/screens/payment/components/paypal_payment.dart';
import 'package:Uthbay/screens/payment/payment_screen.dart';
import 'package:Uthbay/screens/payment/widgets/existing_cards.dart';
import 'package:Uthbay/screens/payment/widgets/new_card.dart';
import 'package:Uthbay/screens/product/cart/cart_page.dart';
import 'package:Uthbay/screens/product/details/product_details.dart';
import 'package:Uthbay/screens/product/product_screen.dart';
import 'package:Uthbay/screens/shop/shop_screen.dart';
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
          create: (context) => GroceryProvider(),
          child: HomeScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomerProvider(),
          child: HomeScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
          child: ProductScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoaderProvider(),
          child: BaseScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoaderProvider(),
          child: CartPage(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: ShopScreen(),
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
        ),
        ChangeNotifierProvider(
          create: (context) => GroceryProvider(),
          child: PickupPage(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: PickupPage(),
        ),
        ChangeNotifierProvider(
          create: (context) => GroceryProvider(),
          child: PaymentScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
          child: Orderspage(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
          child: OrderDetailsPage(),
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
          brightness: Brightness.light,
          accentColor: Colors.redAccent,
          // dividerColor: Colors.redAccent,
          // hintColor: Colors.redAccent,
          focusColor: Colors.redAccent,
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 22.0, color: Colors.redAccent),
            headline2: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: Colors.redAccent,
            ),
            headline3: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
              color: Colors.redAccent,
              height: 1.4,
            ),
            headline4: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: Colors.redAccent,
              height: 1.3,
            ),
            subtitle1: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 1.3,
            ),
            caption: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w300,
              color: Colors.grey,
              height: 1.2,
            ),
            bodyText1: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Colors.blueAccent),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/PayPal': (BuildContext context) => new PaypalPaymentScreen(),
          '/payment': (BuildContext context) => PaymentScreen(),
          '/existing-cards': (BuildContext context) => ExistingCardsPage(),
          '/new-cards': (BuildContext context) => NewCardsPage()
        },
      ),
    );
  }
}
