import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/resources/colors.dart';
import 'package:project/screens/login/controller.dart';
import 'package:project/screens/login/data.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

// ignore: must_be_immutable
class InfoPatient extends StatelessWidget {
  static withDependency() {
    return StateNotifierProvider<LoginController, LoginData>(
        create: (_) => LoginController(), child: InfoPatient());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: color3,
          leading: Icon(Icons.arrow_back, color: color2),
          elevation: 0),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 45),
              child: Image.asset('assets/images/dish2.png')),
          Container(
            padding: EdgeInsets.all(14),
            width: 250,
            color: Colors.blueAccent.withAlpha(80),
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Text('GIAO BAI TAP',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          ),
          Container(
            padding: EdgeInsets.all(14),
            color: Colors.purple,
            width: 250,
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Text('KET QUA LUYEN TAP',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          ),
        ],
      )),
    );
  }
}
