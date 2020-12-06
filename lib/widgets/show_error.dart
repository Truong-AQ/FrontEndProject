import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowErrorOrMsg extends StatelessWidget {
  ShowErrorOrMsg({this.error, this.actions, this.msg});
  final String error, msg;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(error ?? msg,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16.0,
              color: error != null ? Colors.red : Colors.blue,
              fontFamily: 'roboto')),
      actions: actions,
    );
  }
}
