import 'package:Uthbay/models/payment_method.dart';
import 'package:flutter/material.dart';

class PaymentCardActionListItem extends StatelessWidget {
  PaymentMethod paymentMethod;
  Icon icon;
  String title;
  String description;
  int index;
  PaymentCardActionListItem(
      {this.icon, this.title, this.description, this.index});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/new-cards');
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => Payment()));
            break;
          case 1:
            Navigator.pushNamed(context, '/existing-cards');
            break;
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).focusColor.withOpacity(0.000),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).focusColor.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(0, 2))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: icon,
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          description,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Theme.of(context).focusColor,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
