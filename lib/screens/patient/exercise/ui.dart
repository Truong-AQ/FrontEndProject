import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/screens/patient/navigation_home/controller.dart';
import 'package:project/util/function/drawer.dart';
import 'package:project/util/variable.dart';
import 'package:project/screens/patient/exercise/controller.dart';
import 'package:project/screens/patient/test/ui.dart';
import 'package:project/util/function/show_dialog_general.dart';
import 'package:project/widgets/icon_refresh.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'data.dart';

// ignore: must_be_immutable
class Exercise extends StatelessWidget {
  GestureDetector _tabShowDialog;
  static Widget withDependency() {
    return StateNotifierProvider<ExerciseController, ExerciseData>(
      create: (_) => ExerciseController()..initTests(),
      child: Exercise(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: buildDrawerPatient(context),
        appBar: AppBar(
            title: Text('Bài kiểm tra của tôi'),
            centerTitle: true,
            actions: [
              IconRefresh(onPress: () {
                context.read<ExerciseController>().initTests();
              })
            ]),
        body: Selector<ExerciseData, bool>(
          selector: (_, dt) => dt.process,
          builder: (_, process, __) {
            return process
                ? Loading()
                : SingleChildScrollView(
                    child: Container(
                        margin: EdgeInsets.only(top: 15, left: 12, right: 12),
                        child: Column(children: [
                          Selector<ExerciseData, String>(
                            selector: (_, dt) => dt.name,
                            builder: (_, name, __) {
                              Future.delayed(Duration(milliseconds: 500))
                                  .then((_) {
                                context
                                    .read<NavigationHomeController>()
                                    .updateName(name);
                              });
                              return Container();
                            },
                          ),
                          _buildExercise(),
                          _tabShowDialog = GestureDetector(
                              child: Container(),
                              onTap: () {
                                String error =
                                    context.read<ExerciseData>().error;
                                showDialogOfApp(context,
                                    error: error,
                                    onRetry: () => context
                                        .read<ExerciseController>()
                                        .initTests());
                              }),
                          Selector<ExerciseData, int>(
                            selector: (_, dt) => dt.numOfError,
                            builder: (_, __, ___) {
                              Future.delayed(Duration(milliseconds: 500))
                                  .then((_) => _tabShowDialog.onTap());
                              return Container();
                            },
                          )
                        ])),
                  );
          },
        ));
  }

  Widget _buildExercise() {
    return Selector<ExerciseData, List>(
      selector: (_, dt) => dt.test,
      builder: (context, test, __) {
        if (test.length == 0) return Container();
        return Column(children: [
          SizedBox(height: 10),
          for (int i = 0; i < test.length; i++)
            _buildExerciseItem(context,
                text: context.select((ExerciseData dt) => dt.test[i]).label,
                time: context.select((ExerciseData dt) => dt.test[i].time),
                link: context.select((ExerciseData dt) => dt.test[i].link),
                isProcess:
                    context.select((ExerciseData dt) => dt.test[i]).isProcess,
                numAttempt:
                    context.select((ExerciseData dt) => dt.test[i].numAttempts))
        ]);
      },
    );
  }

  Widget _buildExerciseItem(BuildContext context,
      {String text,
      String time,
      String link,
      bool isProcess,
      String numAttempt}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: Colors.blue.withAlpha(30),
          borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(text, style: TextStyle(fontFamily: 'monospace')),
        SizedBox(height: 4),
        time != null
            ? Text(time,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600))
            : SizedBox(height: 0),
        if (time != null) SizedBox(height: 4),
        numAttempt != null
            ? Text(numAttempt,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600))
            : SizedBox(height: 0),
        SizedBox(height: 4),
        Row(children: [
          Spacer(),
          GestureDetector(
            onTap: () async {
              if (link == '#') return;
              await Navigator.push(
                  contextHome,
                  MaterialPageRoute(
                      builder: (_) => Test.withDependency(url: link)));
              context.read<ExerciseController>().initTests();
            },
            child: Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: link == '#'
                        ? Colors.grey
                        : (isProcess ? Colors.pink : Colors.greenAccent)),
                child: Text(
                    link == '#'
                        ? 'HOÀN THÀNH'
                        : (isProcess ? 'TIẾP TỤC' : 'BẮT ĐẦU'),
                    style: TextStyle(color: Colors.white, fontSize: 12))),
          )
        ])
      ]),
    );
  }
}
