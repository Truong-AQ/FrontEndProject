import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/resources/colors.dart';
import 'package:project/resources/dimens.dart';
import 'package:project/screens/questions/complete_sentence/controller.dart';
import 'package:project/screens/questions/complete_sentence/data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

class CompleteSentence extends StatelessWidget {
  static withDependency() {
    return StateNotifierProvider<CompleteSentenceController,
            CompleteSentenceData>(
        create: (_) => CompleteSentenceController(), child: CompleteSentence());
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
      body: SingleChildScrollView(
          child: Column(
        children: [
          _buildImageQuestion(context),
          _buildWordsQuestion(context),
          _buildUserAnswer(context)
        ],
      )),
    );
  }

  Widget _buildImageQuestion(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: dimen2, bottom: dimen2),
      padding: EdgeInsets.all(dimen12),
      child: Container(
        width: dimen14,
        child: Image.asset('assets/images/kettle2.png', fit: BoxFit.fill),
      ),
    );
  }

  Widget _buildWordsQuestion(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: dimen3),
      child: Consumer<CompleteSentenceData>(builder: (_, csd, __) {
        return Wrap(
            alignment: WrapAlignment.center,
            children: [
              for (int i = 0; i < csd.questions.length; i++)
                _buildWord(context, csd.questions, csd.fixed, i),
            ],
            runSpacing: dimen6);
      }),
    );
  }

  Widget _buildWord(BuildContext context, List<String> questions,
      List<bool> fixed, int index) {
    if (fixed[index] || questions[index] == '') return SizedBox(width: 0);
    return GestureDetector(
      onTap: () {
        context.read<CompleteSentenceController>().addAnswer(index);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: dimen5),
        width: dimen6 * questions[index].length,
        child: Text(questions[index],
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
        padding: EdgeInsets.only(
            left: dimen3, right: dimen3, top: dimen15, bottom: dimen15),
        child: Consumer<CompleteSentenceData>(builder: (_, csd, __) {
          final colorAnswer =
              csd.isComplete ? (csd.isCorrect ? color9 : color7) : color2;
          return Wrap(
              alignment: WrapAlignment.center,
              children: [
                for (int i = 0; i < csd.answerUser.length; i++)
                  _buildUserWord(context, i, csd.answerUser, colorAnswer),
              ],
              runSpacing: dimen6);
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
                  context
                      .read<CompleteSentenceController>()
                      .removeAnswer(index);
                },
                child: Text(answers[index],
                    style: TextStyle(
                        color: color,
                        fontSize: dimen12,
                        fontWeight: FontWeight.bold)),
              ));
  }
}
