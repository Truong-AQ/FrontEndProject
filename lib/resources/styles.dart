import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';

import 'colors.dart';
import 'dimens.dart';

const style1 = EdgeInsets.symmetric(horizontal: dimen3);
final style2 = InputDecoration(
  contentPadding: EdgeInsets.all(10),
  border: OutlineInputBorder(),
);
const style3 = TextStyle(fontWeight: FontWeight.bold, fontSize: dimen6);
final style4 =
    TextStyle(color: color2, fontWeight: FontWeight.bold, fontSize: dimen6);
final style5 = BoxDecoration(
    borderRadius: BorderRadius.circular(dimen3),
    color: color4,
    border: Border.all());
final style6 = Style(
    color: color2, fontWeight: FontWeight.bold, fontSize: FontSize(dimen6));
final style7 = BoxDecoration(color: color4, border: Border.all());
