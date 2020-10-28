import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project/util/mixin.dart';
import 'package:project/screens/login/ui.dart';

class Splash extends StatelessWidget with PortraitModeMixin {
  static Widget withDependency() {
    return Splash();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Timer(Duration(seconds: 2), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => Login.withDependency()));
    });
    return Scaffold(
      body: Stack(children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset('assets/images/splash.png', fit: BoxFit.fill)),
        Positioned(
            bottom: 40,
            left: 25,
            right: 25,
            child: Text('Ung dung dieu tri ngon ngu - You play - We care',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace'),
                textAlign: TextAlign.center))
      ]),
    );
  }
}
