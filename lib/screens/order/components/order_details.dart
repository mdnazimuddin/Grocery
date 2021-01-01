import 'package:Uthbay/models/cart_response_model.dart';
import 'package:Uthbay/models/order.dart';
import 'package:Uthbay/models/order_detail.dart';
import 'package:Uthbay/models/shipping_model.dart';
import 'package:Uthbay/provider/order_provider.dart';
import 'package:Uthbay/screens/checkout/widgets/checkpoints.dart';
import 'package:Uthbay/screens/widgets/cart_notify.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailsPage extends StatefulWidget {
  int orderId;
  OrderDetailsPage({this.orderId});
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();

    var orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.fetchOrder(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: new Consumer<OrderProvider>(
        builder: (context, orderModel, child) {
          if (orderModel.order.id != null) {
            return orderDetailUI(orderModel.order, context);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget orderDetailUI(Order model, BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "#${model.orderNumber.toString()}",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Text(
            model.orderDate.toString() ?? '',
            style: Theme.of(context).textTheme.labelText,
          ),
          SizedBox(height: 20),
          Text(
            "Delivered To",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Text(
            model.shipping.address1 ?? '',
            style: Theme.of(context).textTheme.labelText,
          ),
          Text(
            model.shipping.address2 ?? "",
            style: Theme.of(context).textTheme.labelText,
          ),
          Text(
            "${model.shipping.city ?? ''},${model.shipping.state ?? ''}",
            style: Theme.of(context).textTheme.labelText,
          ),
          SizedBox(height: 20),
          Text(
            "Payment Method",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Text(
            model.payment.paymentMethod ?? '',
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
          _itemTotal("Item Total", "${model.itemTotal ?? ''}",
              textStyle: Theme.of(context).textTheme.itemTotalText),
          _itemTotal("Items Taxes", model.productTax ?? '',
              textStyle: Theme.of(context).textTheme.itemTotalText),
          _itemTotal("Uthbay Service Charges", model.uthbayService ?? '',
              textStyle: Theme.of(context).textTheme.itemTotalText),
          _itemTotal("Shipping Charges", "${model.delivery ?? ''}",
              textStyle: Theme.of(context).textTheme.itemTotalText),
          _itemTotal("Total (${model.payment.setPaid ? "Paid" : "Due"})",
              "${model.totalAmount ?? ''}",
              textStyle: Theme.of(context).textTheme.itemTotalPaidText),
        ],
      ),
    );
  }

  Widget _listOrderItems(Order model) {
    return ListView.builder(
      itemCount: model.items.length,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (contex, index) {
        return _productItems(model.items[index]);
      },
    );
  }

  Widget _productItems(CartItem product) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.all(2),
      onTap: () {},
      title: new Text(
        product.variationId == 0
            ? product.productName
            : "${product.productName} (${product.attributeValue} ${product.attribute})",
        style: Theme.of(context).textTheme.productItemText,
      ),
      subtitle: Padding(
        padding: EdgeInsets.all(1),
        child: Text("Qty: ${product.qty ?? ''}"),
      ),
      trailing: Text("\$ ${product.lineTotal ?? ''}"),
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

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.redAccent,
      brightness: Brightness.dark,
      elevation: 0,
      automaticallyImplyLeading: true,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context)),
      title: Text(
        "Order Details",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        cartNotify(context),
        SizedBox(width: 10),
      ],
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
