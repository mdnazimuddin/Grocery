import 'package:flutter/material.dart';

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
                              height: 14,
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
                    Container(
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
                              height: 14,
                              child: Icon(Icons.email),
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
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 49),
                      child: Container(
                        height: 42,
                        width: 262,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border:
                                Border.all(width: 1, color: Color(0xFFA7A3A3))),
                        child: Center(
                          child: Text(
                            "I'll use email or phone",
                            style: TextStyle(
                                color: Color(0xFF5960FF),
                                fontSize: 16,
                                fontStyle: FontStyle.italic),
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
                          "Alredy have account?",
                          style: TextStyle(
                              color: Color(0xFFA7A3A3),
                              fontStyle: FontStyle.italic,
                              fontSize: 16),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Color(0xFF5960FF),
                                fontSize: 16,
                                fontStyle: FontStyle.italic),
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
