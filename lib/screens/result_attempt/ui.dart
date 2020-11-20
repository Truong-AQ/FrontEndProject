import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/screens/result_attempt/controller.dart';
import 'package:project/screens/result_attempt/data.dart';
import 'package:project/screens/result_detail/ui.dart';
import 'package:project/util/show_dialog_general.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ResultTestTime extends StatelessWidget {
  static Widget withDependency({String dataUri, String label}) {
    return StateNotifierProvider<ResultTestTimeController, ResultTestTimeData>(
        create: (_) => ResultTestTimeController(dataUri),
        child: ResultTestTime(label: label));
  }

  ResultTestTime({this.label});
  final String label;
  GestureDetector _tabShowDialog;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label), centerTitle: true),
      body: context.select((ResultTestTimeData dt) => dt.init)
          ? SingleChildScrollView(
              child: Column(
              children: [
                Selector<ResultTestTimeData, int>(
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
                ),
                _tabShowDialog = GestureDetector(
                    child: Container(),
                    onTap: () {
                      String error = context.read<ResultTestTimeData>().error;
                      showDialogOfApp(context,
                          error: error,
                          onRetry: () =>
                              context.read<ResultTestTimeController>().init());
                    }),
                Selector<ResultTestTimeData, int>(
                  selector: (_, dt) => dt.numOfError,
                  builder: (_, __, ___) {
                    Future.delayed(Duration(milliseconds: 500))
                        .then((_) => _tabShowDialog.onTap());
                    return Container();
                  },
                ),
              ],
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
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ResultDetail.withDependency(
                          id: rs.id,
                          label: label,
                          classUri:
                              context.read<ResultTestTimeData>().dataUri)));
            },
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
