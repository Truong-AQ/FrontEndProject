import 'package:flutter/material.dart';
import 'package:project/screens/login/ui.dart';
import 'package:project/util/variable.dart';

void logout() {
  prefs.setString('cookie', '');
  Navigator.pushReplacement(
      contextHome, MaterialPageRoute(builder: (_) => Login.withDependency()));
  freeVariable();
}

void freeVariable() {
  commonDataQuestion = null;
  contextHome = null;
  testOfUser = [];
  prefs = null;
  cookie = '';
  nameTestTaker = '';
}
