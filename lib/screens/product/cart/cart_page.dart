import 'package:Uthbay/models/grocery_list.dart';
import 'package:Uthbay/provider/cart_provider.dart';
import 'package:Uthbay/provider/grocery_provider.dart';
import 'package:Uthbay/provider/loader_provider.dart';
import 'package:Uthbay/screens/checkout/components/pickpu.dart';
import 'package:Uthbay/screens/product/widgets/cart_product.dart';
import 'package:Uthbay/screens/widgets/cart_notify.dart';
import 'package:Uthbay/utilis/ProgressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  GroceryList grocery;
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        grocery = Provider.of<GroceryProvider>(context, listen: false).grocery;
      });
      var cartItemList = Provider.of<CartProvider>(context, listen: false);
      cartItemList.resetStreams();
      cartItemList.fetchCartItems(int.parse(grocery.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _cartItemsList(),
    );

    // return CartProduct(data: cartItem);
  }

  Widget _cartItemsList() {
    return new Consumer<CartProvider>(
      builder: (context, cartModel, child) {
        if (cartModel.cartItems != null && cartModel.cartItems.length > 0) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.start,

                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: cartModel.cartItems.length,
                      itemBuilder: (context, index) {
                        print(cartModel.cartItems[index]);
                        return CartProduct(
                          data: cartModel.cartItems[index],
                          groceryId: grocery.id,
                        );
                      },
                    ),
                    // Padding(
                    //   padding: EdgeInsets.all(10),
                    //   child: Align(
                    //     alignment: Alignment.centerRight,
                    //     child: FlatButton(
                    //       child: Wrap(
                    //         alignment: WrapAlignment.center,
                    //         crossAxisAlignment: WrapCrossAlignment.center,
                    //         children: [
                    //           Icon(
                    //             Icons.sync,
                    //             color: Colors.white,
                    //           ),
                    //           Text(
                    //             "Update Cart",
                    //             style: TextStyle(color: Colors.white),
                    //           )
                    //         ],
                    //       ),
                    //       onPressed: () {
                    //         Provider.of<LoaderProvider>(context, listen: false)
                    //             .setLoadingStatus(true);
                    //         var cartProvider = Provider.of<CartProvider>(
                    //             context,
                    //             listen: false);
                    //         cartProvider.updateCart(
                    //           int.parse(widget.groceryId),
                    //           (val) {
                    //             Provider.of<LoaderProvider>(context,
                    //                     listen: false)
                    //                 .setLoadingStatus(false);
                    //             print(val);
                    //           },
                    //         );
                    //       },
                    //       padding: EdgeInsets.all(5),
                    //       color: Colors.green,
                    //       shape: StadiumBorder(),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "\$${cartModel.totalAmount}",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Checkout',
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(Icons.chevron_right, color: Colors.white)
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: PickupPage()));
                        },
                        padding: EdgeInsets.all(15),
                        color: Colors.redAccent,
                        shape: StadiumBorder(),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        } else if (cartModel.dataNotFound) {
          print(cartModel.dataNotFound);
          return Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Text("Cart items not found")],
              ),
            ),
          );
        } else {
          return Shimmer.fromColors(
            baseColor: Colors.grey[900],
            highlightColor: Colors.grey[200],
            enabled: true,
            child: shimmerCartProductList(),
          );
        }
      },
    );
  }

  Widget shimmerCartProductList() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (_, __) {
        return ListTile(
          // contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent.withOpacity(0.02),
            child: ClipOval(
              child: Container(
                width: 148.0,
                height: 148.0,
                color: Colors.black12,
              ),
            ),
          ),
          title: Container(
            width: 48.0,
            height: 10.0,
            color: Colors.black12,
          ),
          subtitle: Container(
            width: 48.0,
            height: 10.0,
            color: Colors.black12,
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.black12),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.redAccent,
      brightness: Brightness.dark,
      elevation: 0,
      automaticallyImplyLeading: true,
      title: Text(
        this.grocery.name.toString(),
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context)),
    );
  }
}
