import 'package:flutter/material.dart';
import 'package:project/resources/colors.dart';
import 'package:project/resources/dimens.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color4.withAlpha(dimen11),
      body: Center(child: CircularProgressIndicator(backgroundColor: color4)),
    );
  }
}
