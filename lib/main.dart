import 'package:flutter/material.dart';
import 'package:project/screens/login/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        color: Colors.blue,
        home: Login.withDependency(),
        debugShowCheckedModeBanner: false);
  }
}
