import 'package:Uthbay/screens/signin/signin_screen.dart';
import 'package:Uthbay/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class BasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35.0),
                  bottomRight: Radius.circular(35.0)),
              child: Image(image: AssetImage("assets/images/background.jpg")),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 2),
              child: Center(
                child: Column(
                  children: [
                    // Text(
                    //   "UTHBAY GROCERY",
                    //   style: TextStyle(
                    //     color: Colors.redAccent,
                    //     fontSize: 24,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Sign up",
                      style: TextStyle(
                        color: Color(0xFF151B4A),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      "it's easier to sign up now",
                      style: TextStyle(
                          color: Color(0xFF151B4A),
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 36,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 49),
                      child: Container(
                        height: 42,
                        width: 262,
                        decoration: BoxDecoration(
                            color: Color(0xFF5960FF),
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.8),
                                  blurRadius: 4)
                            ]),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 24,
                              child: Image(
                                image: AssetImage("assets/images/google.png"),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                "Continue with Google",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: SignUpScreen()));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 49),
                        child: Container(
                          height: 42,
                          width: 262,
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.8),
                                    blurRadius: 4)
                              ]),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 24,
                                child: Image(
                                  image: AssetImage("assets/images/gmail.png"),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Continue with Email",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                              color: Color(0xFFA7A3A3),
                              fontStyle: FontStyle.italic,
                              fontSize: 16),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: SignInScreen()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
