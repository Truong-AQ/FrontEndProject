import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/screens/login/ui.dart';
import 'package:project/screens/navigation_home/ui.dart';
import 'package:project/screens/splash/controller.dart';
import 'package:project/screens/splash/data.dart';
import 'package:project/util/mixin.dart';
import 'package:provider/provider.dart';

class Splash extends StatelessWidget with PortraitModeMixin {
  static Widget withDependency() {
    return StateNotifierProvider<SplashController, SplashData>(
      create: (_) => SplashController()..initDataSet(),
      child: Splash(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return context.select((SplashData dt) => dt.init)
        ? (context.select((SplashData dt) => dt.cookie) == ''
            ? Login.withDependency()
            : NavigationHome.withDependency())
        : Scaffold(
            body: Stack(children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Image.asset('assets/images/splash.png',
                      fit: BoxFit.fill)),
              Positioned(
                  bottom: 40,
                  left: 25,
                  right: 25,
                  child: Text('Ứng dụng trị liệu ngôn ngữ\nYou play - We care',
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
