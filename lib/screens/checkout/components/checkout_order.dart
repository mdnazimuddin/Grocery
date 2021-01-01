import 'package:Uthbay/models/cart_response_model.dart';
import 'package:Uthbay/models/order.dart';
import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/provider/grocery_provider.dart';
import 'package:Uthbay/screens/checkout/checkout_base.dart';
import 'package:Uthbay/screens/payment/payment_screen.dart';
import 'package:Uthbay/utilis/form_helper.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class CheckoutOrder extends CheckoutBasePage {
  @override
  _CheckoutOrderState createState() => _CheckoutOrderState();
}

class _CheckoutOrderState extends CheckoutBasePageState<CheckoutOrder> {
  String uthbayService;
  String productTaxes;
  String delivery;
  String itemsAmount;
  String total;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentPage = 0;
    var grocery = Provider.of<GroceryProvider>(context, listen: false).grocery;
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.fetchShippingDetails();
    cartProvider.fetchOrderTax(grocery.id);
  }

  @override
  Widget pageUI() {
    return orderDetailUI();
  }

  Widget orderDetailUI() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          shippingAddress(),
          Divider(color: Colors.grey),
          SizedBox(height: 5),
          _orderItems(),
          SizedBox(height: 5),
          _orderLabel(),
          SizedBox(height: 15),
          Center(
            child: FormHelper.saveButton(
              "Place order",
              () {
                var grocery =
                    Provider.of<GroceryProvider>(context, listen: false)
                        .grocery;
                var cartProvider =
                    Provider.of<CartProvider>(context, listen: false);
                print(grocery.address.state);
                cartProvider.orderModel.groceryId = int.parse(grocery.id);
                cartProvider.orderModel.itemTotal = itemsAmount;
                cartProvider.orderModel.productTax = productTaxes;
                cartProvider.orderModel.delivery = delivery;
                cartProvider.orderModel.uthbayService = uthbayService;
                cartProvider.orderModel.totalAmount = total;

                cartProvider.orderModel.billing = new Billing();
                cartProvider.orderModel.billing.address1 =
                    grocery.address.address_1;
                cartProvider.orderModel.billing.address2 =
                    grocery.address.address_2;
                cartProvider.orderModel.billing.city = grocery.address.city;
                cartProvider.orderModel.billing.state = grocery.address.state;
                cartProvider.orderModel.billing.postcode = grocery.address.zip;
                cartProvider.orderModel.billing.company = grocery.name;

                // cartProvider.createOrder();
                if (total != null && double.parse(total) > 0) {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: PaymentScreen()));
                }
              },
              fullWidth: true,
            ),
          )
        ],
      ),
    );
  }

  Widget shippingAddress() {
    return Consumer<CartProvider>(
      builder: (context, order, child) {
        if (order.shipping != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Delivered To",
                style: Theme.of(context).textTheme.labelHeading,
              ),
              Text(
                order.shipping.address1 ?? "",
                style: Theme.of(context).textTheme.labelText,
              ),
              Text(
                order.shipping.address2 ?? "",
                style: Theme.of(context).textTheme.labelText,
              ),
              Text(
                "${order.shipping.city ?? ""},${order.shipping.state ?? ""}",
                style: Theme.of(context).textTheme.labelText,
              ),
            ],
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _orderLabel() {
    return Consumer<CartProvider>(
      builder: (context, cartModel, child) {
        if (cartModel.orderTax.groceryId != null) {
          itemsAmount = "${cartModel.totalAmount}";
          uthbayService =
              "${((cartModel.orderTax.uthbayService * cartModel.totalAmount) / 100).toStringAsFixed(2)}";
          productTaxes =
              "${((cartModel.orderTax.productTax * cartModel.totalAmount) / 100).toStringAsFixed(2)}";
          delivery = cartModel.orderTax.delivery;

          total =
              "${(cartModel.totalAmount + double.parse(uthbayService) + double.parse(productTaxes) + double.parse(delivery)).toStringAsFixed(2)}";

          return Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black12.withOpacity(.05),
            ),
            child: Column(
              children: [
                _orderShop(),
                _orderProductTaxes(),
                _orderDeliveryService(),
                _orderUthbayService(),
                Divider(color: Colors.grey, height: 10),
                _itemTotal(),
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _orderShop() {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 2, right: 2),
      onTap: () {},
      title: new Text(
        Provider.of<GroceryProvider>(context, listen: false)
            .grocery
            .name
            .toString(),
        style: Theme.of(context).textTheme.shopTitle,
      ),
      trailing: Text("\$ ${itemsAmount ?? ""}",
          style: Theme.of(context).textTheme.shopAmount),
    );
  }

  Widget _orderUthbayService() {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 2, right: 2),
      onTap: () {},
      title: new Text(
        "Uthbay Service",
        style: Theme.of(context).textTheme.serviceTitle,
      ),
      trailing: Text("\$ ${uthbayService ?? ""}",
          style: Theme.of(context).textTheme.shopAmount),
    );
  }

  Widget _orderDeliveryService() {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 2, right: 2),
      onTap: () {},
      title: new Text(
        "Delivery",
        style: Theme.of(context).textTheme.shopTitle,
      ),
      trailing: Text("\$ ${delivery ?? "FREE"}",
          style: Theme.of(context).textTheme.shopAmount),
    );
  }

  Widget _orderProductTaxes() {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 2, right: 2),
      onTap: () {},
      title: new Text(
        "Product taxes",
        style: Theme.of(context).textTheme.shopTitle,
      ),
      subtitle: Text("(estimated)"),
      trailing: Text("\$ ${productTaxes ?? ""}",
          style: Theme.of(context).textTheme.shopAmount),
    );
  }

  Widget _itemTotal() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      contentPadding: EdgeInsets.fromLTRB(2, -10, 2, -10),
      title: Text(
        "Total",
        style: Theme.of(context).textTheme.itemTotalText,
      ),
      trailing: Text("\$ ${total ?? ""}",
          style: Theme.of(context).textTheme.itemTotalPaidText),
    );
  }

  Widget _orderItems() {
    return new Consumer<CartProvider>(
      builder: (context, cartModel, child) {
        if (cartModel.cartItems != null && cartModel.cartItems.length > 0) {
          var cartProvider = Provider.of<CartProvider>(context, listen: false);
          cartProvider.orderModel.items = List<CartItem>();
          cartProvider.orderModel.items = cartModel.cartItems;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Order Summary",
                  style: Theme.of(context).textTheme.headline6),
              _listOrderItems(cartModel.cartItems),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget _listOrderItems(List<CartItem> items) {
    return ListView.builder(
      itemCount: items.length,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (contex, index) {
        return _productItems(items[index]);
      },
    );
  }

  Widget _productItems(CartItem item) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.all(2),
      onTap: () {},
      title: new Text(
        item.variationId == 0
            ? item.productName
            : "${item.productName} (${item.attributeValue} ${item.attribute})",
        style: Theme.of(context).textTheme.productItemText,
      ),
      subtitle: Padding(
        padding: EdgeInsets.all(1),
        child: Text("Qty: ${item.qty}"),
      ),
      trailing: Text("\$ ${item.productSalePrice}"),
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

  TextStyle get shopTitle {
    return TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );
  }

  TextStyle get shopAmount {
    return TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );
  }

  TextStyle get serviceTitle {
    return TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle get itemTotalText {
    return TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get itemTotalPaidText {
    return TextStyle(
      fontSize: 16.0,
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
}
