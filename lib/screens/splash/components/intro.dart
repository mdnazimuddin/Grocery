import 'package:Uthbay/screens/signin/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'base.dart';

class IntroScreen extends StatelessWidget {
  final pageDecoration = PageDecoration(
    titleTextStyle:
        PageDecoration().titleTextStyle.copyWith(color: Colors.redAccent),
    bodyTextStyle: PageDecoration()
        .bodyTextStyle
        .copyWith(color: Colors.redAccent, fontSize: 10),
    contentPadding: const EdgeInsets.all(10),
  );

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
          image: Image.asset("assets/images/on_the_way.png"),
          title: "First delivery",
          bodyWidget: Text(
            "We deliver your groceries in first delivery",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.redAccent, fontWeight: FontWeight.normal),
          ),
          // footer: Text(
          //   "UTHBAY GROCERY",
          //   style:
          //       TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
          // ),
          decoration: pageDecoration),
      PageViewModel(
          image: Image.asset("assets/images/groceries.png"),
          title: "Select your favorite store",
          bodyWidget: Text(
            "Choose from thousands of products from your favorite stores.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.redAccent, fontWeight: FontWeight.normal),
          ),
          // footer: Text(
          //   "UTHBAY GROCERY",
          //   style:
          //       TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
          // ),
          decoration: pageDecoration),
      PageViewModel(
          image: Image.asset("assets/images/time_management.png"),
          title: "Save Time",
          bodyWidget: Text(
            "Let us take care of your groceries so you have more time for the thimgs you love",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.redAccent, fontWeight: FontWeight.normal),
          ),
          // footer: Text(
          //   "UTHBAY GROCERY",
          //   style:
          //       TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
          // ),
          decoration: pageDecoration),
      PageViewModel(
          image: Image.asset("assets/images/shopping_app.png"),
          title: "Your personal Shopper",
          bodyWidget: Text(
            "Your Shopper picks with pride and will call you before leaving the store to make sure your order is perfect.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.redAccent, fontWeight: FontWeight.normal),
          ),
          // footer: Text(
          //   "UTHBAY GROCERY",
          //   style:
          //       TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
          // ),
          decoration: pageDecoration),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: getPages(),
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Colors.redAccent,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
        showSkipButton: true,
        skip: const Text(
          "Skip",
          style:
              TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        onSkip: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BasePage()));
        },
        next: Icon(Icons.arrow_forward, color: Colors.redAccent),
        done: Text(
          "Done",
          style:
              TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        onDone: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BasePage()));
        },
      ),
    );
  }
}
