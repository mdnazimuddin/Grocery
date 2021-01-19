import 'package:Uthbay/screens/home/home_screen.dart';
import 'package:Uthbay/screens/signin/signin_screen.dart';
import 'package:Uthbay/screens/signup/signup_screen.dart';
import 'package:Uthbay/screens/splash/components/base.dart';
import 'package:Uthbay/screens/splash/components/intro.dart';
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
  bool install;
  init() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    // user status
    bool _install = sp.getBool('install') ?? false;
    bool _login = sp.getBool('login') ?? false;

    setState(() {
      this.login = _login;
      this.install = _install;
    });
    print("Install: ${_install}");
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
            "assets/logo/grocery_logo_one.png",
            fit: BoxFit.fitHeight,
          ),
        ),
        screenFunction: () async {
          if (login) {
            return HomeScreen();
          } else {
            if (install) {
              return BasePage();
            } else {
              return IntroScreen();
            }
          }
        },
        splashTransition: SplashTransition.scaleTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: Colors.white);
  }
}
