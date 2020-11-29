import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/screens/patient/result_detail/controller.dart';
import 'package:project/screens/patient/result_detail/data.dart';
import 'package:project/util/function/show_dialog_general.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';

class ResultDetail extends StatefulWidget {
  static Widget withDependency({String id, String classUri, String label}) {
    return StateNotifierProvider<ResultDetailController, ResultDetailData>(
        create: (_) => ResultDetailController(id, classUri),
        child: ResultDetail(label: label));
  }

  ResultDetail({this.label});
  final String label;
  @override
  _ResultDetailState createState() => _ResultDetailState();
}

class _ResultDetailState extends State<ResultDetail> {
  GestureDetector _tabShowDialog;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.label)),
      body: context.select((ResultDetailData dt) => dt.init)
          ? Selector<ResultDetailData, int>(
              selector: (_, dt) => dt.points.length,
              builder: (context, length, __) {
                List<int> list =
                    context.select((ResultDetailData dt) => dt.points);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _tabShowDialog = GestureDetector(
                        child: Container(),
                        onTap: () {
                          String error = context.read<ResultDetailData>().error;
                          showDialogOfApp(context,
                              error: error,
                              onRetry: () => context
                                  .read<ResultDetailController>()
                                  .init());
                        }),
                    Selector<ResultDetailData, int>(
                      selector: (_, dt) => dt.numOfError,
                      builder: (_, __, ___) {
                        Future.delayed(Duration(milliseconds: 500))
                            .then((_) => _tabShowDialog.onTap());
                        return Container();
                      },
                    ),
                    SizedBox(height: 10),
                    for (int i = 0; i < length; i++)
                      Container(
                        decoration: BoxDecoration(border: Border.all()),
                        margin: EdgeInsets.only(left: 10, top: 10),
                        padding: EdgeInsets.all(10),
                        child: Text(
                            'Câu hỏi thứ ${i + 1} đạt điểm: ${list[i]}/1',
                            style: TextStyle(
                                fontSize: 14, fontFamily: 'monospace')),
                      ),
                    SizedBox(height: 20),
                    Row(children: [
                      Spacer(),
                      Text(
                          'Tổng điểm: ${context.select((ResultDetailData dt) => dt.totalPoint)}/${context.select((ResultDetailData dt) => dt.points).length}',
                          style:
                              TextStyle(fontSize: 16, fontFamily: 'monospace')),
                      SizedBox(width: 20)
                    ])
                  ],
                );
              },
            )
          : Loading(),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
