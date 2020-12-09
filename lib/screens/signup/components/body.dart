import 'package:Uthbay/models/customer.dart';
import 'package:Uthbay/screens/home/home_screen.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:Uthbay/utilis/ProgressHUD.dart';
import 'package:Uthbay/utilis/form_helper.dart';
import 'package:Uthbay/utilis/validator_service.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  APIService apiService;
  CustomerModel model;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: true,
        title: Text("Sing Up"),
      ),
      body: ProgressHUD(
        child: new Form(
          key: globalKey,
          child: formUI(),
        ),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
      ),
    );
  }

  Widget formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormHelper.fieldLabel("Full Name"),
                FormHelper.textInput(
                  context,
                  model.name,
                  (value) => {this.model.name = value},
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Plesae enter your Full Name';
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("Email Id"),
                FormHelper.textInput(
                  context,
                  model.email,
                  (value) => {this.model.email = value},
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Plesae enter your Email Id';
                    }
                    if (value.isNotEmpty && !value.toString().isValidEmail()) {
                      return 'Plesae enter valid Email Id';
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("Phone Number"),
                FormHelper.textInput(
                  context,
                  model.phone,
                  (value) => {this.model.phone = value},
                  isNumberInput: true,
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Plesae enter your Phone Number';
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("Password"),
                FormHelper.textInput(
                  context,
                  model.password,
                  (value) => {this.model.password = value},
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Plesae enter your Password.';
                    }
                    return null;
                  },
                  obscureText: hidePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    color: Theme.of(context).accentColor.withOpacity(0.4),
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: FormHelper.saveButton("Ragister", () {
                    if (validetAndSave()) {
                      print(model.toJson());
                      setState(() {
                        isApiCallProcess = true;
                      });
                      apiService.createCustomer(model: model).then((ret) {
                        if (ret) {
                          setState(() {
                            FormHelper.showMessage(
                              context,
                              "Uthbay Grocery",
                              "Registation Successfull",
                              "OK",
                              () {
                                // Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              },
                            );
                          });
                        } else {
                          setState(() {
                            FormHelper.showMessage(
                              context,
                              "Uthbay Grocery",
                              "Registation Faild! Please try again.",
                              "OK",
                              () {
                                Navigator.of(context).pop();
                              },
                            );
                          });
                        }
                      });
                    }
                  }),
                )
              ],
            ),
          ),
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
