import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertMessage {
  static void showMessage(
    BuildContext context,
    String title,
    String message,
    String buttonText,
    Function onPressed, {
    bool isConfirmationDialog = false,
    String buttonText2 = "",
    Function onPressed2,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              FlatButton(
                child: Text(buttonText),
                onPressed: () {
                  return onPressed();
                },
              ),
              Visibility(
                visible: isConfirmationDialog,
                child: FlatButton(
                  child: Text(buttonText2),
                  onPressed: () {
                    return onPressed2();
                  },
                ),
              )
            ],
          );
        });
  }
}
