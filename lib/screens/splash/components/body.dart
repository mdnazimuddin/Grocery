import 'package:Uthbay/screens/home/home_screen.dart';
import 'package:Uthbay/screens/signin/signin_screen.dart';
import 'package:Uthbay/screens/signup/signup_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool login;
  init() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    // user status
    bool _login = sp.getBool('login') ?? false;

    setState(() {
      this.login = _login;
    });
    print("New Install: ${login}");
  }

  @override
  void initState() {
    super.initState();
    this.init();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
        duration: 3000,
        splash: SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: Image.asset(
              "assets/logo/uthbay.png",
              fit: BoxFit.cover,
            )),
        screenFunction: () async {
          if (login) {
            return HomeScreen();
          } else {
            return SignUpScreen();
          }
        },
        splashTransition: SplashTransition.scaleTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: Colors.white);
  }
}
