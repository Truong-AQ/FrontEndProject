import 'package:flutter/material.dart';

class IconRefresh extends StatelessWidget {
  IconRefresh({this.onPress});
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(Icons.refresh), onPressed: onPress);
  }
}
