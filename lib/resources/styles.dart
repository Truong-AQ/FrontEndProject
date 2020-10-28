import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'dimens.dart';

const style1 = EdgeInsets.symmetric(horizontal: dimen3);
final style2 = InputDecoration(
  contentPadding: EdgeInsets.all(10),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(dimen4)),
);
const style3 = TextStyle(fontWeight: FontWeight.bold, fontSize: dimen6);
final style4 =
    TextStyle(color: color2, fontWeight: FontWeight.bold, fontSize: dimen6);
final style5 = BoxDecoration(
    borderRadius: BorderRadius.circular(dimen3),
    color: color4,
    border: Border.all());
