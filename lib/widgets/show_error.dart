import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/resources/colors.dart';
import 'package:project/resources/dimens.dart';

class ShowError extends StatelessWidget {
  ShowError({this.error, this.actions});
  final String error;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(error,
          textAlign: TextAlign.center,
          style:
              TextStyle(fontSize: dimen6, color: color4, fontFamily: 'roboto')),
      actions: actions,
    );
  }
}
