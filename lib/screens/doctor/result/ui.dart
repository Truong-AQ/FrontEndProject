import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'controller.dart';
import 'data.dart';
import 'package:project/screens/patient/result_attempt/ui.dart';
import 'package:project/util/function/drawer.dart';
import 'package:project/util/function/show_dialog_general.dart';
import 'package:project/widgets/icon_refresh.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
  static Widget withDependency() {
    return StateNotifierProvider<ResultController, ResultData>(
        create: (_) => ResultController(), child: Result());
  }
}

class _ResultState extends State<Result> {
  GestureDetector _tabShowDialog;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: buildDrawerDoctor(context),
        appBar: AppBar(
            title: Text('Kết quả của tôi'),
            centerTitle: true,
            actions: [
              IconRefresh(
                  onPress: () => context.read<ResultController>().initResult())
            ]),
        body: Selector<ResultData, bool>(
          selector: (_, dt) => dt.process,
          builder: (_, process, __) {
            if (process) return Loading();
            return SingleChildScrollView(
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
                                  text: list[i].label,
                                  dataUri: list[i].dataUri),
                          ]);
                    },
                  ),
                  _tabShowDialog = GestureDetector(
                      child: Container(),
                      onTap: () {
                        String error = context.read<ResultData>().error;
                        showDialogOfApp(context,
                            error: error,
                            onRetry: () =>
                                context.read<ResultController>().initResult());
                      }),
                  Selector<ResultData, int>(
                    selector: (_, dt) => dt.numOfError,
                    builder: (_, __, ___) {
                      Future.delayed(Duration(milliseconds: 500))
                          .then((_) => _tabShowDialog.onTap());
                      return Container();
                    },
                  )
                ],
              ),
            );
          },
        ));
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
                          listTestTaker: [], dataUri: dataUri, label: text)));
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
