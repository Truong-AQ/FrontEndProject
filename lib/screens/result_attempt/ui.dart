import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/screens/result_attempt/controller.dart';
import 'package:project/screens/result_attempt/data.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';

class ResultTestTime extends StatelessWidget {
  static Widget withDependency({String dataUri}) {
    return StateNotifierProvider<ResultTestTimeController, ResultTestTimeData>(
        create: (_) => ResultTestTimeController(dataUri), child: ResultTestTime());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: context.select((ResultTestTimeData dt) => dt.init) ? Container() :
      Loading(),
    );
  }
}
