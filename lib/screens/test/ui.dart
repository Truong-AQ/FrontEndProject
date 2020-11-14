import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/screens/questions/choice/ui.dart';
import 'package:project/screens/questions/order_sentence/ui.dart';
import 'package:project/screens/questions/pairing/ui.dart';
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
    return !context.select((TestData dt) => dt.init)
        ? Loading(backgroundColor: Colors.white)
        : Scaffold(body: LayoutBuilder(builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                    child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // _TimeTest(time: 5),
                                // SizedBox(height: 4),
                                _QuestionCurrent()
                              ]),
                          Spacer(),
                          _buildNextButton(context)
                        ],
                      ),
                    ),
                    Selector<TestData, bool>(
                      selector: (_, dt) => dt.process,
                      builder: (_, process, __) {
                        return process
                            ? Expanded(
                                child:
                                    Center(child: CircularProgressIndicator()))
                            : _buildQuestion(context);
                      },
                    )
                  ],
                )),
              ),
            );
          }));
  }

  Widget _buildNextButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!context.read<TestData>().process) {
/*          await context.read<TestController>().moveItemForNextItem(
              listAnswer: convertListAnswer(
                  answer: commonDataQuestion.userAnswer,
                  typeQuestion: context.read<TestData>().typeQuestionCurrent),
              timeDuration: DateTime.now()
                      .difference(commonDataQuestion.timeStart)
                      .inMicroseconds /
                  1000000);*/
          if (context.read<TestData>().idQuestions.length !=
              context.read<TestData>().questionCurrent)
            await context.read<TestController>().getNextItem();
          else {
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

// ignore: must_be_immutable
class _TimeTest extends StatefulWidget {
  _TimeTest({
    Key key,
    this.time,
  }) : super(key: key);
  int time;
  Timer timer;
  @override
  __TimeTestState createState() => __TimeTestState();
}

class __TimeTestState extends State<_TimeTest> {
  get time => widget.time;
  void downTime() => widget.time -= 1;
  get timer => widget.timer;
  set timer(Timer timer) => widget.timer = timer;
  @override
  void initState() {
    super.initState();
    hour = time ~/ 3600;
    minute = (time - hour * 3600) ~/ 60;
    second = (time - hour * 3600 - minute * 60);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        downTime();
        second--;
        if (second == -1) {
          second = 59;
          minute--;
          if (minute == -1) {
            hour--;
            minute = 59;
            if (hour == -1) {
              hour = minute = second = 0;
              timer.cancel();
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('Thoi gian con lai: $hour:$minute:$second',
        style: TextStyle(fontSize: 14, fontFamily: 'monospace'));
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  int hour, minute, second;
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
