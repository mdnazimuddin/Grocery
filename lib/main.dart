import 'dart:ui';

import 'package:Uthbay/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Grocery',
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
  ));
}
