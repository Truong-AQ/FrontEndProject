import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/resources/types.dart';
import 'package:project/screens/patient/questions/choice/ui.dart';
import 'package:project/screens/patient/questions/order_sentence/ui.dart';
import 'package:project/screens/patient/questions/pairing/ui.dart';
import 'package:project/screens/patient/test/controller.dart';
import 'package:project/screens/patient/test/data.dart';
import 'package:project/util/function/convert_answer.dart';
import 'package:project/util/function/show_dialog_general.dart';
import 'package:project/util/variable.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Test extends StatelessWidget {
  static Widget withDependency({String url}) {
    return StateNotifierProvider<TestController, TestData>(
      create: (_) => TestController(url: url)..initData(),
      child: Test(),
    );
  }

  GestureDetector _tabShowDialog;
  @override
  Widget build(BuildContext context) {
    return !context.select((TestData dt) => dt.init)
        ? Loading(backgroundColor: Colors.white)
        : Scaffold(
            body: SingleChildScrollView(
            child: Column(
              children: [
                _tabShowDialog = GestureDetector(
                    child: Container(),
                    onTap: () {
                      String error = context.read<TestData>().error;
                      UserAction action = context.read<TestData>().action;
                      Function onRetry;
                      if (action is InitLoad)
                        onRetry =
                            () => context.read<TestController>().initData();
                      else if (action is GetNextQuestion)
                        onRetry =
                            () => context.read<TestController>().getNextItem();
                      else if (action is SubmitQuestion) {
                        Map<String, dynamic> data = action.data;
                        onRetry = () => context
                            .read<TestController>()
                            .moveItemForNextItem(
                                listAnswer: data['listAnswer'],
                                timeDuration: data['timeDuration']);
                      }
                      showDialogOfApp(context,
                          error: error,
                          onRetry: onRetry,
                          typeWidgetCurrent: Test);
                    }),
                Selector<TestData, int>(
                  selector: (_, dt) => dt.numOfError,
                  builder: (_, __, ___) {
                    Future.delayed(Duration(milliseconds: 500))
                        .then((_) => _tabShowDialog.onTap());
                    return Container();
                  },
                ),
                SizedBox(height: MediaQuery.of(context).padding.top),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      _QuestionCurrent(),
                      Spacer(),
                      _buildNextButton(context)
                    ],
                  ),
                ),
                Selector<TestData, bool>(
                  selector: (_, dt) => dt.process,
                  builder: (_, process, __) {
                    final error = context.read<TestData>().error;
                    if (error != '') return Container();
                    if (process) gifLoading.evict();
                    return process
                        ? Center(
                            child: Column(children: [
                              SizedBox(height: 80),
                              Image(image: gifLoading),
                              SizedBox(height: 15),
                              Text('Dữ liệu đang được tải đừng nóng ...',
                                  style: TextStyle(
                                      fontFamily: 'monospace', fontSize: 16))
                            ]),
                          )
                        : _buildQuestion(context);
                  },
                )
              ],
            ),
          ));
  }

  Widget _buildNextButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!context.read<TestData>().process) {
          final listAnswer = convertListAnswer(
              answer: commonDataQuestion.userAnswer,
              typeQuestion: context.read<TestData>().typeQuestionCurrent);
          final timeDuration = DateTime.now()
                  .difference(commonDataQuestion.timeStart)
                  .inMicroseconds /
              1000000;
          context.read<TestController>().updateUserAction(SubmitQuestion()
            ..addData('listAnswer', listAnswer)
            ..addData('timeDuration', timeDuration));
          bool moveQuestion = await context
              .read<TestController>()
              .moveItemForNextItem(
                  listAnswer: listAnswer, timeDuration: timeDuration);

          if (!moveQuestion) return;
          if (context.read<TestData>().idQuestions.length !=
              context.read<TestData>().questionCurrent) {
            context.read<TestController>().updateUserAction(GetNextQuestion());
            await context.read<TestController>().getNextItem();
          } else {
            Navigator.pop(context);
          }
        }
      },
      child: Container(
          padding: EdgeInsets.all(8),
          color: Colors.orange,
          child: _TextNextOrEnd()),
    );
  }

  Widget _buildQuestion(BuildContext context) {
    return Selector<TestData, int>(
      selector: (_, dt) => dt.questionCurrent,
      builder: (context, index, _) {
        if (index == 0) return Container();
        switch (context.select((TestData dt) => dt.typeQuestionCurrent)) {
          case TypeQuestion.ASSIGNING:
            return Choice.withDependency(
                context.select((TestData dt) => dt.dataQuestion));
          case TypeQuestion.SORT:
            return OrderSentence.withDependency(
                context.select((TestData dt) => dt.dataQuestion));
          case TypeQuestion.PAIRING:
            return Pairing.withDependency(
                context.select((TestData dt) => dt.dataQuestion));
        }
        return Container();
      },
    );
  }
}

class _TextNextOrEnd extends StatelessWidget {
  const _TextNextOrEnd({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        context.select(
                (TestData dt) => dt.questionCurrent == dt.idQuestions.length)
            ? 'KET THUC'
            : 'KE TIEP',
        style: TextStyle(
            fontFamily: 'monospace',
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold));
  }
}

class _QuestionCurrent extends StatelessWidget {
  const _QuestionCurrent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        'Cau hoi thu ${context.select((TestData dt) => dt.questionCurrent)} / ${context.select((TestData dt) => dt.idQuestions.length)}',
        style: TextStyle(fontSize: 14, fontFamily: 'monospace'));
  }
}
