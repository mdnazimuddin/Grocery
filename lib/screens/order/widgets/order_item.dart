import 'package:Uthbay/models/order.dart';
import 'package:Uthbay/models/order_model.dart';
import 'package:Uthbay/screens/order/components/order_details.dart';
import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  OrderModel orderModel;
  OrderItem({this.orderModel});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          _orderStatus(this.orderModel.status),
          Divider(color: Colors.grey),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              iconText(
                Icon(Icons.edit, color: Colors.redAccent),
                Text(
                  "Order ID",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                this.orderModel.orderNumber.toString(),
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              iconText(
                Icon(Icons.today, color: Colors.redAccent),
                Text(
                  "Order Date",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                this.orderModel.orderDate.toString(),
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              flatButton(
                Row(children: [
                  Text("  Order Details  "),
                  Icon(Icons.chevron_right),
                ]),
                Colors.green,
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderDetailsPage()));
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget iconText(Icon iconWidget, Text textWidget) {
    return Row(
      children: [
        iconWidget,
        SizedBox(width: 5),
        textWidget,
      ],
    );
  }

  Widget flatButton(Widget iconText, Color color, Function onPressed) {
    return FlatButton(
      child: iconText,
      onPressed: onPressed,
      padding: EdgeInsets.all(5),
      color: color,
      shape: StadiumBorder(),
    );
  }

  Widget _orderStatus(String status) {
    Icon icon;
    Color color;

    if (status == "pending" || status == "processing" || status == "on-hold") {
      icon = Icon(Icons.timer, color: Colors.orange);
      color = Colors.orange;
    } else if (status == "completed") {
      icon = Icon(Icons.check, color: Colors.green);
      color = Colors.green;
    } else if (status == "cancelled" ||
        status == "refunded" ||
        status == "failed") {
      icon = Icon(Icons.clear, color: Colors.redAccent);
      color = Colors.redAccent;
    } else {
      icon = Icon(Icons.clear, color: Colors.redAccent);
      color = Colors.redAccent;
    }
    return iconText(
        icon,
        Text(
          "Order $status",
          style: TextStyle(
            fontSize: 15,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
