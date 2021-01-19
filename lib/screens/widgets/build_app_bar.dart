import 'package:flutter/material.dart';

Widget buildAppBar(context, {title,action}) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.white, //change your color here
    ),
    centerTitle: true,
    backgroundColor: Colors.redAccent,
    brightness: Brightness.dark,
    elevation: 0,
    automaticallyImplyLeading: true,
    title: title ?? applogo(context),
    actions: action ?? [],
  );
}

Widget applogo(context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * .3,
    child: Image.asset('assets/logo/uthbay-white.png', fit: BoxFit.cover),
  );
}
