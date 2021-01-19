import 'package:Uthbay/screens/widgets/build_app_bar.dart';
import 'package:flutter/material.dart';

import 'components/customer_profile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context,
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          )),
      body: CustomerProfile(),
    );
  }
}
