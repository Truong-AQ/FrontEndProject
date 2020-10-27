import 'package:flutter/material.dart';
import 'package:project/screens/home/ui.dart';
import 'package:project/screens/list_patient/ui.dart';
import 'package:project/screens/login/ui.dart';
import 'package:project/screens/manage_patient/ui.dart';
import 'package:project/screens/questions/complete_sentence/ui.dart';
import 'package:project/screens/questions/order_sentence/ui.dart';
import 'package:project/screens/questions/pairing/ui.dart';
import 'package:project/screens/questions/single_choice/ui.dart';
import 'package:project/screens/register/ui.dart';
import 'package:project/screens/search/ui.dart';

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
    return Column(
      children: [
        SizedBox(height: 50),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Login.withDependency();
              }));
            },
            child: Text('Login')),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Register.withDependency();
              }));
            },
            child: Text('Register')),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Search.withDependency();
              }));
            },
            child: Text('Search')),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return SingleChoice.withDependency();
              }));
            },
            child: Text('Single Choice')),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return OrderSentence.withDependency();
              }));
            },
            child: Text('Order Sentence')),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return CompleteSentence.withDependency();
              }));
            },
            child: Text('Complete Sentence')),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Pairing.withDependency();
              }));
            },
            child: Text('Pair Word')),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Register.withDependency();
              }));
            },
            child: Text('Register Patient')),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ManagePatient.withDependency();
              }));
            },
            child: Text('Manage Patient')),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ListPatient.withDependency();
              }));
            },
            child: Text('List Patient')),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Home.withDependency();
              }));
            },
            child: Text('Home'))
      ],
    );
  }
}
