import 'package:Uthbay/models/login_model.dart';
import 'package:Uthbay/models/order.dart';
import 'package:Uthbay/models/order_model.dart';
import 'package:Uthbay/provider/order_provider.dart';
import 'package:Uthbay/screens/order/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Orderspage extends StatefulWidget {
  @override
  _OrderspageState createState() => _OrderspageState();
}

class _OrderspageState extends State<Orderspage> {
  List<OrderModel> orders;
  @override
  void initState() {
    super.initState();
    orders = new List<OrderModel>();
    OrderModel order = OrderModel(
      status: "pending",
      orderNumber: "231234",
      orderDate: DateTime.parse("2020-12-12T21:28:36"),
    );

    OrderModel order2 = OrderModel(
      status: "completed",
      orderNumber: "65478",
      orderDate: DateTime.parse("2020-18-12T21:28:36"),
    );

    orders.add(order);
    orders.add(order2);

    // var orderProvider = Provider.of<OrderProvider>(context, listen: false);
    // orderProvider.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return _listView(context, orders);
    // return new Consumer<OrderProvider>(builder: (context, orderModel, child) {
    //   if (orderModel.allOrders != null && orderModel.allOrders.length > 0) {
    //     return _listView(context, orders);
    //   } else {
    //     return Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   }
    // });
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
