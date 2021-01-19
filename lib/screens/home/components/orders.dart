import 'dart:ui';

import 'package:Uthbay/models/order_model.dart';
import 'package:Uthbay/provider/grocery_provider.dart';
import 'package:Uthbay/provider/order_provider.dart';
import 'package:Uthbay/screens/order/widgets/order_item.dart';
import 'package:Uthbay/screens/widgets/build_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyOrderspage extends StatefulWidget {
  @override
  _MyOrderspageState createState() => _MyOrderspageState();
}

class _MyOrderspageState extends State<MyOrderspage> {
  // List<OrderModel> orders;
  @override
  void initState() {
    super.initState();
    var orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    // return _listView(context, orders);
    return Scaffold(
      appBar: buildAppBar(context,
          title: Text(
            "My Orders",
            style: TextStyle(color: Colors.white),
          )),
      body: new Consumer<OrderProvider>(builder: (context, orderModel, child) {
        if (orderModel.allOrders != null && orderModel.allOrders.length > 0) {
          return _listView(context, orderModel.allOrders);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }

  Widget _listView(BuildContext context, List<OrderModel> order) {
    return ListView(
      children: [
        ListView.builder(
          itemCount: order.length,
          physics: ScrollPhysics(),
          padding: EdgeInsets.all(8),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: OrderItem(orderModel: order[index]),
            );
          },
        ),
      ],
    );
  }
}
