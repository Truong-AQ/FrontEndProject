import 'package:flutter/material.dart';
import 'package:project/screens/home/ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        color: Colors.blue, home: Test(), debugShowCheckedModeBanner: false);
  }
}

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return Home.withDependency();
          }));
        },
        child: Text('Enter'));
  }
}
