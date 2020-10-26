import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/resources/colors.dart';
import 'package:project/resources/dimens.dart';
import 'package:project/screens/questions/order_sentence/controller.dart';
import 'package:project/screens/questions/order_sentence/data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

class OrderSentence extends StatelessWidget {
  static withDependency() {
    return StateNotifierProvider<OrderSentenceController, OrderSentenceData>(
        create: (_) => OrderSentenceController(), child: OrderSentence());
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
                  _buildUserAnswer(context)
                ],
              )),
            ),
          );
        }));
  }

  Widget _buildQuestion(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: dimen2, bottom: dimen2),
      padding: EdgeInsets.all(dimen12),
      child: Container(
        width: dimen14,
        child: Image.asset('assets/images/dish2.png', fit: BoxFit.fill),
      ),
    );
  }

  Widget _buildAnswer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: dimen3),
      child: Consumer<OrderSentenceData>(builder: (_, osd, __) {
        return Wrap(alignment: WrapAlignment.center, children: [
          for (int i = 0; i < osd.answers.length; i++)
            _buildWord(context, osd.answers, i),
        ]);
      }),
    );
  }

  Widget _buildWord(BuildContext context, List<String> answers, int index) {
    if (answers[index] == '') return SizedBox(width: 0);
    return GestureDetector(
      onTap: () {
        context.read<OrderSentenceController>().addAnswer(index);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: dimen5),
        width: dimen6 * answers[index].length,
        child: Text(answers[index],
            style: TextStyle(
                color: color2, fontSize: dimen12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
      ),
    );
  }

  Widget _buildUserAnswer(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: dimen3, right: dimen3, top: dimen15),
        child: Consumer<OrderSentenceData>(builder: (_, osd, __) {
          final colorAnswer =
              osd.isComplete ? (osd.isCorrect ? color9 : color7) : color2;
          return Wrap(children: [
            for (int i = 0; i < osd.answerUser.length - 1; i++)
              _buildUserWord(context, i, osd.answerUser, colorAnswer),
          ]);
        }));
  }

  Widget _buildUserWord(
      BuildContext context, int index, List<String> answers, Color color) {
    return Container(
        height: dimen8,
        margin: EdgeInsets.symmetric(horizontal: dimen5),
        padding: EdgeInsets.only(bottom: dimen18),
        alignment: Alignment.center,
        width: answers[index] == '' ? dimen17 : answers[index].length * dimen6,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: color, width: dimen16)),
        ),
        child: answers[index] == ''
            ? Container()
            : GestureDetector(
                onTap: () {
                  context.read<OrderSentenceController>().removeAnswer(index);
                },
                child: Text(answers[index],
                    style: TextStyle(
                        color: color,
                        fontSize: dimen12,
                        fontWeight: FontWeight.bold)),
              ));
  }
}
