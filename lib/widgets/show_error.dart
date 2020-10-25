import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowError extends StatelessWidget {
  ShowError({this.error, this.actions});
  final String error;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(error,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16.0, color: Colors.red, fontFamily: 'roboto')),
      actions: actions,
    );
  }
}
