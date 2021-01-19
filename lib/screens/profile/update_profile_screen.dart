import 'dart:convert';
import 'dart:io';
import 'package:Uthbay/models/customer.dart';
import 'package:Uthbay/screens/home/home_screen.dart';
import 'package:Uthbay/screens/widgets/build_app_bar.dart';
import 'package:Uthbay/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';

class UpdateProfileScreen extends StatefulWidget {
  final CustomerModel customer;
  UpdateProfileScreen({this.customer});
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  APIService apiService;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isApiCallProcess = false;
  CustomerModel customer = new CustomerModel();

  ProgressDialog pr;

  File _image;
  Future<File> file;

  String base64Image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiService = new APIService();
    customer = widget.customer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(context,
          title: Text(
            'Update Profile',
            style: TextStyle(color: Colors.white),
          )),
      body: updateProfileForm(context),
    );
  }

  Widget updateProfileForm(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Form(
          key: globalKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                onSaved: (input) => customer.firstName = input,
                initialValue: customer.firstName,
                validator: (input) =>
                    input.length <= 0 ? "Enter first Name." : null,
                decoration: InputDecoration(
                  hintText: "Enter a first name",
                  labelText: "First Name",
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.text,
                onSaved: (input) => customer.lastName = input,
                initialValue: customer.lastName,
                validator: (input) =>
                    input.length <= 0 ? "Enter a last name" : null,
                decoration: InputDecoration(
                  hintText: "Enter a last name",
                  labelText: "Last Name",
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.text,
                onSaved: (input) => customer.email = input,
                initialValue: customer.email,
                validator: (input) =>
                    input.length <= 0 ? "Enter Valid Email." : null,
                decoration: InputDecoration(
                  hintText: "Enter Email Address",
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.text,
                onSaved: (input) => customer.phone = input,
                initialValue: customer.phone,
                validator: (input) =>
                    input.length <= 0 ? "Enter Valid Phone Number." : null,
                decoration: InputDecoration(
                  hintText: "Enter a Phone Number",
                  labelText: "Phone",
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              GestureDetector(
                child: showImage(),
                onTap: _onAlertPress,
              ),
              SizedBox(height: 30),
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                onPressed: () async {
                  if (validetAndSave()) {
                    setState(() {
                      isApiCallProcess = true;
                    });
                    ProgressDialog dialog = new ProgressDialog(context);
                    dialog.style(message: 'Please wait...');
                    await dialog.show();
                    apiService.updateProfile(customer).then((ret) async {
                      await dialog.hide();
                      if (ret) {
                        final snackBar = SnackBar(
                            content: Text("Profile Update Successfull"),
                            duration: new Duration(milliseconds: 500));
                        _scaffoldKey.currentState
                            .showSnackBar(snackBar)
                            .closed
                            .then((_) {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: HomeScreen()));
                        });
                      } else {
                        final snackBar = SnackBar(
                            content: Text("Sorry! Profile Update Faild"),
                            duration: new Duration(milliseconds: 1200));
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                      }
                    });
                  }
                },
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).accentColor,
                shape: StadiumBorder(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          customer.img = base64Image;
          return Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                child:
                    showBase64Image(base64Image: base64Image, fit: BoxFit.fill),
              ),
            ],
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black12),
              child: Image.asset('assets/images/addphoto.png'));
        }
      },
    );
  }

  //========================= Gellary / Camera AlerBox
  void _onAlertPress() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/gallery.png',
                      width: 50,
                    ),
                    Text('Gallery'),
                  ],
                ),
                onPressed: getGalleryImage,
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/upload.png',
                      width: 50,
                    ),
                    Text('Take Photo'),
                  ],
                ),
                onPressed: getCameraImage,
              ),
            ],
          );
        });
  }

  // ================================= Image from camera
  Future getCameraImage() async {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.camera);
      Navigator.pop(context);
    });
  }

  //============================== Image from gallery
  Future getGalleryImage() async {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
      Navigator.pop(context);
    });
  }

  Widget showBase64Image({@required base64Image, BoxFit fit}) {
    return Image.memory(
      Base64Decoder().convert(base64Image),
      fit: fit ?? BoxFit.fill,
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
