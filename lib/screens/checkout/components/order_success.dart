import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/screens/checkout/checkout_base.dart';
import 'package:Uthbay/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderSuccess extends CheckoutBasePage {
  @override
  _OrderSuccessState createState() => _OrderSuccessState();
}

class _OrderSuccessState extends CheckoutBasePageState<OrderSuccess> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.currentPage = 2;
    this.showBackbutton = false;

    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    orderProvider.createOrder();
  }

  @override
  Widget pageUI() {
    return Consumer<CartProvider>(
      builder: (context, orderModel, chile) {
        if (orderModel.isOrderCreated) {
          return Center(
            child: Container(
              margin: EdgeInsets.only(top: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Colors.green.withOpacity(1),
                              Colors.green.withOpacity(0.2),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 90,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Opacity(
                    opacity: 0.6,
                    child: Text(
                      "You order has been successfully submitted!",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  SizedBox(height: 20),
                  FlatButton(
                    child: Text(
                      "Done",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          ModalRoute.withName('/home'));
                    },
                    padding: EdgeInsets.all(15),
                    color: Colors.green,
                  )
                ],
              ),
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
}
