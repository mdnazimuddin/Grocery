import 'dart:ui';

import 'package:Uthbay/models/customer.dart';
import 'package:Uthbay/screens/home/home_screen.dart';
import 'package:Uthbay/screens/signup/signup_screen.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:Uthbay/utilis/ProgressHUD.dart';
import 'package:Uthbay/utilis/form_helper.dart';
import 'package:Uthbay/utilis/validator_service.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  APIService apiService;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool hidePassword = true;
  bool isApiCallProcess = false;
  String email;
  String password;

  @override
  void initState() {
    super.initState();
    apiService = new APIService();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              child: Image.asset('assets/logo/uthbay-white.png'),
            ),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).hintColor.withOpacity(0.2),
                            offset: Offset(0, 10),
                            blurRadius: 20)
                      ]),
                  child: Form(
                    key: globalKey,
                    child: Column(
                      children: [
                        SizedBox(height: 25),
                        Text(
                          "Login",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                          ),
                          keyboardType: TextInputType.text,
                          onSaved: (input) => email = input,
                          validator: (input) => !input.contains('@')
                              ? "Email Id should be valid."
                              : null,
                          decoration: InputDecoration(
                            hintText: "Email Address",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 14),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.2),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            prefixIcon: Icon(Icons.email,
                                color: Theme.of(context).accentColor),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: TextStyle(color: Colors.black54),
                          keyboardType: TextInputType.text,
                          onSaved: (input) => password = input,
                          validator: (input) => input.length < 3
                              ? "Password should be more than 3 characters."
                              : null,
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 14),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.2),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            prefixIcon: Icon(Icons.lock,
                                color: Theme.of(context).accentColor),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.4),
                              icon: Icon(hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 80),
                          onPressed: () async {
                            if (validetAndSave()) {
                              ProgressDialog dialog =
                                  new ProgressDialog(context);
                              dialog.style(message: 'Please wait...');
                              await dialog.show();
                              apiService
                                  .loginCustomer(email, password)
                                  .then((ret) async {
                                await dialog.hide();
                                if (ret) {
                                  final snackBar = SnackBar(
                                      content: Text("Login Successfull"),
                                      duration:
                                          new Duration(milliseconds: 800));
                                  _scaffoldKey.currentState
                                      .showSnackBar(snackBar)
                                      .closed
                                      .then((_) {
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: HomeScreen()));
                                  });
                                } else {
                                  final snackBar = SnackBar(
                                      content: Text(
                                          "Username and Password invalid."),
                                      duration:
                                          new Duration(milliseconds: 1500));
                                  _scaffoldKey.currentState
                                      .showSnackBar(snackBar);
                                }
                              });
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).accentColor,
                          shape: StadiumBorder(),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Dont't have an account? "),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: SignUpScreen()));
                              },
                              child: Text("Register",
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.w500,
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool validetAndSave() {
    final form = globalKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
