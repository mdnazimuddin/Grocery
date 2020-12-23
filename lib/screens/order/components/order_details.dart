
import 'package:Uthbay/models/order_detail.dart';
import 'package:Uthbay/models/shipping_model.dart';
import 'package:Uthbay/screens/checkout/widgets/checkpoints.dart';
import 'package:flutter/material.dart';

class OrderDetailsPage extends StatefulWidget {
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    OrderDetailModel orderDetailModel = new OrderDetailModel();
    orderDetailModel.orderId = 1;
    orderDetailModel.orderDate = DateTime.parse("2020-12-19T20:38:00");
    orderDetailModel.paymentMethod = "Paypal";
    orderDetailModel.shipping = new Shipping();
    orderDetailModel.shipping.address1 = "E72";
    orderDetailModel.shipping.address2 = "Sector 62";
    orderDetailModel.shipping.state = "UP";
    orderDetailModel.shipping.city = "Noida";
    orderDetailModel.shippingTotal = 15;
    orderDetailModel.totalAmount = 1300;

    orderDetailModel.lineItems = new List<LineItems>();

    orderDetailModel.lineItems.add(new LineItems(
      productId: 1,
      productName: "Test 1",
      quantity: 10,
      totalAmount: 500,
    ));

    orderDetailModel.lineItems.add(new LineItems(
      productId: 2,
      productName: "Test 2",
      quantity: 5,
      totalAmount: 800,
    ));

    return orderDetailUI(orderDetailModel);
  }

  Widget orderDetailUI(OrderDetailModel model) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "#${model.orderId.toString()}",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Text(
            model.orderDate.toString(),
            style: Theme.of(context).textTheme.labelText,
          ),
          SizedBox(height: 20),
          Text(
            "Delivered To",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Text(
            model.shipping.address1,
            style: Theme.of(context).textTheme.labelText,
          ),
          Text(
            model.shipping.address2,
            style: Theme.of(context).textTheme.labelText,
          ),
          Text(
            "${model.shipping.city},${model.shipping.state}",
            style: Theme.of(context).textTheme.labelText,
          ),
          SizedBox(height: 20),
          Text(
            "Payment Method",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Text(
            model.paymentMethod,
            style: Theme.of(context).textTheme.labelText,
          ),
          Divider(color: Colors.grey),
          SizedBox(height: 5),
          CheckPoints(
            checkedTill: 0,
            checkPoints: ["Processing", "Shipping", "Delivered"],
            checkPointFilledColor: Colors.redAccent,
          ),
          Divider(color: Colors.grey),
          _listOrderItems(model),
          Divider(color: Colors.grey),
          _itemTotal("Item Total", "${model.itemTotalAmount}",
              textStyle: Theme.of(context).textTheme.itemTotalText),
          _itemTotal("Uthbay Service Charges", "65",
              textStyle: Theme.of(context).textTheme.itemTotalText),
          _itemTotal("Shipping Charges", "${model.shippingTotal}",
              textStyle: Theme.of(context).textTheme.itemTotalText),
          _itemTotal("Paid", "${model.totalAmount}",
              textStyle: Theme.of(context).textTheme.itemTotalPaidText),
        ],
      ),
    );
  }

  Widget _listOrderItems(OrderDetailModel model) {
    return ListView.builder(
      itemCount: model.lineItems.length,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (contex, index) {
        return _productItems(model.lineItems[index]);
      },
    );
  }

  Widget _productItems(LineItems product) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.all(2),
      onTap: () {},
      title: new Text(
        product.productName,
        style: Theme.of(context).textTheme.productItemText,
      ),
      subtitle: Padding(
        padding: EdgeInsets.all(1),
        child: Text("Qty: ${product.quantity}"),
      ),
      trailing: Text("\$ ${product.totalAmount}"),
    );
  }

  Widget _itemTotal(String label, String value, {TextStyle textStyle}) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      contentPadding: EdgeInsets.fromLTRB(2, -10, 2, -10),
      title: Text(
        label,
        style: textStyle,
      ),
      trailing: Text("\$ $value"),
    );
  }
}

extension CustomStyle on TextTheme {
  TextStyle get labelHeading {
    return TextStyle(
      fontSize: 16,
      color: Colors.redAccent,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get labelText {
    return TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get productItemText {
    return TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );
  }

  TextStyle get itemTotalText {
    return TextStyle(
      fontSize: 14,
      color: Colors.black,
    );
  }

  TextStyle get itemTotalPaidText {
    return TextStyle(
      fontSize: 16.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }
}
