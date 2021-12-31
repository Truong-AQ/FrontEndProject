import 'package:flutter/material.dart';
import 'package:project/screens/splash/ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        color: Colors.blue,
        home: Splash.withDependency(),
        debugShowCheckedModeBanner: false);
  }
}
// C:\Users\truong.nguyenvan\AppData\Local\Android\Sdk