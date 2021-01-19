import 'package:Uthbay/models/customer.dart';
import 'package:Uthbay/screens/profile/update_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerProfile extends StatefulWidget {
  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  CustomerModel customer = new CustomerModel();
  getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _firstName = prefs.getString('first_name');
    String _lastName = prefs.getString('last_name');
    String _email = prefs.getString('email');
    String _phone = prefs.getString('phone');
    String _imgUrl = prefs.getString('img_src');
    setState(() {
      customer.firstName = _firstName;
      customer.lastName = _lastName;
      customer.email = _email;
      customer.phone = _phone;
      customer.img = _imgUrl;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
          color: Colors.grey[200],
        ),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.50,
              height: MediaQuery.of(context).size.width * 0.50,
              child: CircleAvatar(
                backgroundColor: Colors.blueAccent.withOpacity(0.02),
                child: customer.img == 'null' || customer.img == null
                    ? Image.asset('assets/images/boy.png')
                    : ClipOval(
                        child: Image.network(
                          customer.img,
                          width: MediaQuery.of(context).size.width * 0.50,
                          height: MediaQuery.of(context).size.width * 0.50,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: Text(
                "${customer.firstName} ${customer.lastName}",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ),
            Divider(color: Colors.white),
            Container(
              child: Text(
                "${customer.email}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
            Divider(color: Colors.white),
            Container(
              child: Text(
                "${customer.phone ?? '--- ---'}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
            Divider(color: Colors.white),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Center(
                child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: UpdateProfileScreen(customer: customer)));
                  },
                  child: Text(
                    "Update",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).accentColor,
                  shape: StadiumBorder(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
