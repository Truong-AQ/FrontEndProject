import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/screens/test/controller.dart';
import 'package:project/screens/test/data.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';

class Test extends StatelessWidget {
  static Widget withDependency({String url}) {
    return StateNotifierProvider<TestController, TestData>(
      create: (_) => TestController(url: url)..initData(),
      child: Test(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return context.select((TestData dt) => dt.process)
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
                child: Text(context.select((TestData dt) => dt.token))));
  }
}
