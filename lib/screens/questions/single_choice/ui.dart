import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/resources/colors.dart';
import 'package:project/resources/dimens.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/screens/questions/single_choice/controller.dart';
import 'package:project/screens/questions/single_choice/data.dart';

class SingleChoice extends StatelessWidget {
  static withDependency() {
    return StateNotifierProvider<SingleChoiceController, SingleChoiceData>(
        create: (_) => SingleChoiceController(), child: SingleChoice());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: color8,
            title: Text('BAI TAP',
                style: TextStyle(
                    fontSize: dimen12,
                    color: color2,
                    fontWeight: FontWeight.bold)),
            elevation: 0),
        body: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                  child: Column(
                children: [
                  _buildQuestion(context),
                  _buildAnswer(context),
                ],
              )),
            ),
          );
        }));
  }

  Widget _buildQuestion(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: dimen1, bottom: dimen1),
      padding: EdgeInsets.all(dimen12),
      decoration: BoxDecoration(border: Border.all()),
      child: Text('CAI AM NUOC',
          style: TextStyle(
              color: color2, fontWeight: FontWeight.bold, fontSize: dimen3)),
    );
  }

  Widget _buildAnswer(BuildContext context) {
    List<String> answers = [
      'assets/images/kettle.png',
      'assets/images/bowl.png',
      'assets/images/water_bottle.png',
      'assets/images/dish.png'
    ];
    return Table(
      children: [
        TableRow(children: [
          _buildCellRow(answers[0], context),
          _buildCellRow(answers[1], context)
        ]),
        TableRow(children: [
          _buildCellRow(answers[2], context),
          _buildCellRow(answers[3], context)
        ])
      ],
    );
  }

  Widget _buildCellRow(String url, BuildContext context) {
    return Container(
        padding: EdgeInsets.all(dimen12),
        child: GestureDetector(
          onTap: () {
            context.read<SingleChoiceController>().setAnswer(url);
          },
          child: Selector<SingleChoiceData, String>(
              selector: (_, scd) => scd.answerChoice,
              builder: (context, answer, __) {
                return Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: answer == url
                                ? (context.select(
                                        (SingleChoiceData scd) => scd.isCorrect)
                                    ? color9
                                    : color7)
                                : color3)),
                    child: Image.asset(url, fit: BoxFit.fill));
              }),
        ));
  }
}
