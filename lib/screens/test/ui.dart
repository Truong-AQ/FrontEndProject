import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/screens/questions/choice/ui.dart';
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
                                Text('Thoi gian con lai: 1:23:22',
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: 'monospace')),
                                SizedBox(height: 4),
                                Text('Cau hoi thu 1 / 8',
                                    style: TextStyle(
                                        fontSize: 14, fontFamily: 'monospace'))
                              ]),
                          Spacer(),
                          Container(
                              padding: EdgeInsets.all(8),
                              color: Colors.orange,
                              child: Text('KE TIEP',
                                  style: TextStyle(
                                      fontFamily: 'monospace',
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)))
                        ],
                      ),
                    ),
                    _buildQuestion(context)
                  ],
                )),
              ),
            );
          }));
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
            return Container();
          case TypeQuestion.INSERTION:
            return Container();
        }
        return Container();
      },
    );
  }
}
