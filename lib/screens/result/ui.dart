import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/screens/result/controller.dart';
import 'package:project/screens/result/data.dart';
import 'package:project/screens/result_attempt/ui.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
  static Widget withDependency() {
    return StateNotifierProvider<ResultController, ResultData>(
        create: (_) => ResultController(), child: Result());
  }
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: GlobalKey(),
      onVisibilityChanged: (VisibilityInfo info) {
        var visiblePercentage = info.visibleFraction * 100;

        if (visiblePercentage == 0.0) {
          try {
            context.read<ResultController>().stopPolling();
          } on Error catch (_) {}
        } else if (visiblePercentage == 100.0)
          context.read<ResultController>().startPolling();
      },
      child: Scaffold(
          appBar: AppBar(title: Text('Kết quả của tôi'), centerTitle: true),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                Selector<ResultData, int>(
                  selector: (_, dt) => dt.result.length,
                  builder: (context, length, __) {
                    List<ResultTest> list =
                        context.select((ResultData dt) => dt.result);
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < list.length; i++)
                            _buildResultItem(context,
                                text: list[i].label, dataUri: list[i].dataUri),
                        ]);
                  },
                )
              ],
            ),
          )),
    );
  }

  Widget _buildResultItem(BuildContext context, {String text, String dataUri}) {
    return Container(
      decoration: BoxDecoration(color: Colors.blue.withAlpha(30)),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(text, style: TextStyle(fontFamily: 'monospace')),
        SizedBox(height: 4),
        Row(children: [
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ResultTestTime.withDependency(
                          dataUri: dataUri, label: text)));
            },
            child: Container(
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: Colors.grey),
                child: Text('XEM KẾT QUẢ',
                    style: TextStyle(color: Colors.white, fontSize: 12))),
          )
        ])
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ResultController>(context, listen: false).initResult();
  }
}
