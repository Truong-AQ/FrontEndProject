import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/resources/colors.dart';
import 'package:project/resources/dimens.dart';
import 'package:project/screens/questions/pairing/controller.dart';
import 'package:project/screens/questions/pairing/data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

class Pairing extends StatelessWidget {
  static withDependency() {
    return StateNotifierProvider<PairingController, PairingData>(
        create: (_) => PairingController(), child: Pairing());
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
          _buildWordsQuestion(context),
          _buildPairUserAnswer(context),
          _buildResult(context)
        ],
      )),
    );
  }

  Widget _buildWordsQuestion(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 30),
        padding: EdgeInsets.symmetric(horizontal: dimen3),
        child: Consumer<PairingData>(
          builder: (_, pd, __) {
            return Wrap(
                alignment: WrapAlignment.center,
                children: [
                  for (int i = 0; i < pd.questions.length; i++)
                    _buildWord(context, pd.questions, i),
                ],
                runSpacing: 27);
          },
        ));
  }

  Widget _buildWord(BuildContext context, List<String> questions, int index) {
    if (questions[index] == '') return SizedBox(width: 0);
    return GestureDetector(
      onTap: () {
        context.read<PairingController>().addAnswer(index);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.pink.withAlpha(45),
            borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.symmetric(horizontal: dimen5),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: Text(questions[index],
            style: TextStyle(
                color: color2, fontSize: 17, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
      ),
    );
  }

  Widget _buildPairUserAnswer(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 40),
        child: Consumer<PairingData>(builder: (_, pd, __) {
          return Column(children: [
            for (int i = 0; i < pd.answerUser.length; i += 2)
              Row(children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      context.read<PairingController>().removeAnswer(i);
                    },
                    child: Container(
                        margin: EdgeInsets.all(12),
                        padding: EdgeInsets.all(20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.greenAccent),
                        child: Text(pd.answerUser[i],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontFamily: 'monospace'))),
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    context.read<PairingController>().removeAnswer(i + 1);
                  },
                  child: Container(
                      margin: EdgeInsets.all(12),
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.yellow),
                      child: Text(pd.answerUser[i + 1],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'monospace'))),
                ))
              ]),
          ]);
        }));
  }

  Widget _buildResult(BuildContext context) {
    return Selector<PairingData, bool>(
      selector: (_, pd) => pd.isComplete,
      builder: (context, isComplete, _) {
        return isComplete
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                child: context.select((PairingData pd) => pd.isCorrect)
                    ? Image.asset('assets/images/icon_tick.png')
                    : Image.asset(
                        'assets/images/icon_wrong.png',
                        color: Colors.red,
                      ))
            : Container();
      },
    );
  }
}
