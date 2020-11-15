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
        create: (_) => ResultTestTimeController(dataUri),
        child: ResultTestTime());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: context.select((ResultTestTimeData dt) => dt.init)
          ? SingleChildScrollView(
              child: Selector<ResultTestTimeData, int>(
              selector: (_, dt) => dt.list.length,
              builder: (context, length, __) {
                List<ResultByTime> list =
                    context.select((ResultTestTimeData dt) => dt.list);
                return Column(
                  children: [
                    for (int i = 0; i < list.length; i++)
                      _buildResultByTimeItem(context, list[i]),
                  ],
                );
              },
            ))
          : Loading(),
    );
  }

  Widget _buildResultByTimeItem(BuildContext context, ResultByTime rs) {
    return Container(
      decoration: BoxDecoration(color: Colors.blue.withAlpha(30)),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(rs.time, style: TextStyle(fontFamily: 'monospace')),
        SizedBox(height: 4),
        Row(children: [
          Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: Colors.grey),
                child: Text('XEM LẠI',
                    style: TextStyle(color: Colors.white, fontSize: 12))),
          )
        ])
      ]),
    );
  }
}
