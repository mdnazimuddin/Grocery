import 'package:Uthbay/models/customer.dart';
import 'package:Uthbay/screens/home/home_screen.dart';
import 'package:Uthbay/screens/signin/signin_screen.dart';
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
  CustomerModel model;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool hidePassword = true;
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    model = new CustomerModel();
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
              height: 150,
              child: Image.asset('assets/logo/uthbay-white.png'),
            ),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                        Text(
                          "Register New Account",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                          keyboardType: TextInputType.text,
                          onSaved: (input) => model.firstName = input,
                          validator: (input) => input.toString().isEmpty
                              ? "Plesae enter your first name."
                              : null,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 0, bottom: 0, left: 8, right: 8),
                            hintText: "First Name",
                            labelText: "First Name",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: Colors.black54),
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
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                          keyboardType: TextInputType.text,
                          onSaved: (input) => model.lastName = input,
                          validator: (input) => input.toString().isEmpty
                              ? "Plesae enter your last name."
                              : null,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 0, bottom: 0, left: 8, right: 8),
                            hintText: "Last Name",
                            labelText: "Last Name",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: Colors.black54),
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
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                          keyboardType: TextInputType.text,
                          onSaved: (input) => model.email = input,
                          validator: (input) {
                            if (input.toString().isEmpty) {
                              return 'Plesae enter your Email Id';
                            }
                            if (input.isNotEmpty &&
                                !input.toString().isValidEmail()) {
                              return 'Plesae enter valid Email Id';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 0, bottom: 0, left: 8, right: 8),
                            hintText: "Email Address",
                            labelText: "Email ",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: Colors.black54),
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
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                          keyboardType: TextInputType.text,
                          onSaved: (input) => model.password = input,
                          validator: (input) => input.length < 3
                              ? "Password should be more than 3 characters."
                              : null,
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                            hintText: "Password",
                            labelText: "Password ",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: Colors.black54),
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
                        SizedBox(height: 15),
                        FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 80),
                          onPressed: () async {
                            if (validetAndSave()) {
                              print(model.toJson());
                              ProgressDialog dialog =
                                  new ProgressDialog(context);
                              dialog.style(message: 'Please wait...');
                              await dialog.show();
                              apiService
                                  .createCustomer(model: model)
                                  .then((ret) async {
                                await dialog.hide();
                                if (ret) {
                                  final snackBar = SnackBar(
                                      content: Text("Registation Successfull"),
                                      duration:
                                          new Duration(milliseconds: 1200));
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
                                          "Registation Faild! Please try again."),
                                      duration:
                                          new Duration(milliseconds: 1200));
                                  _scaffoldKey.currentState
                                      .showSnackBar(snackBar);
                                }
                              });
                            }
                          },
                          child: Text(
                            "Register",
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
                            Text("Already have an account? "),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: SignInScreen()));
                              },
                              child: Text("Login",
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
