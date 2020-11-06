import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/resources/colors.dart';
import 'package:project/resources/dimens.dart';
import 'package:project/screens/questions/order_sentence/controller.dart';
import 'package:project/screens/questions/order_sentence/data.dart';
import 'package:project/screens/test/data.dart';
import 'package:project/widgets/PlayAudio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

class OrderSentence extends StatelessWidget {
  static withDependency(Map<String, dynamic> data) {
    return StateNotifierProvider<OrderSentenceController, OrderSentenceData>(
        create: (_) => OrderSentenceController(data), child: OrderSentence());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(top: 10),
              child: _buildSuggest(context,
                  Provider.of<OrderSentenceData>(context, listen: false).suggest)),
          _buildLabel(
              context, Provider.of<OrderSentenceData>(context, listen: false).label),
          _buildAnswer(
              context, Provider.of<OrderSentenceData>(context, listen: false).answers)
          _buildUserAnswer(
              context, Provider.of<OrderSentenceData>(context, listen: false).answers)
        ],
      )),
    );
  }

  Widget _buildSuggest(BuildContext context, AnswerChoice suggest) {
    if (suggest.type == 'audio') return PlayAudio(url: suggest.data);
    if(suggest.type == 'image') return Container(
      width: 200,
      height: 200,
      child: Image.network(suggest.data, fit: BoxFit.fill,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              context.read<OrderSentenceController>().updateTime(DateTime.now());
              return child;
            }
            return Center(
              child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                      : null),
            );
          }),
    );
    return Container();
  }

  Widget _buildLabel(BuildContext context, String label) {
    if (label == null) return Container();
    return Container(
      margin: EdgeInsets.only(top: 35, bottom: dimen1),
      padding: EdgeInsets.all(dimen12),
      decoration: BoxDecoration(border: Border.all()),
      child: Text(label,
          style: TextStyle(
              color: color2, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
  Widget _buildWordsQuestion(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: dimen3),
      child: Consumer<OrderSentenceData>(builder: (_, osd, __) {
        return Wrap(
            alignment: WrapAlignment.center,
            children: [
              for (int i = 0; i < osd.questions.length; i++)
                _buildWord(context, osd.questions, i),
            ],
            runSpacing: dimen6);
      }),
    );
  }

  Widget _buildWord(BuildContext context, List<String> questions, int index) {
    if (questions[index] == '') return SizedBox(width: 0);
    return GestureDetector(
      onTap: () {
        context.read<OrderSentenceController>().addAnswer(index);
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
        child: Consumer<OrderSentenceData>(builder: (_, osd, __) {
          final colorAnswer =
              osd.isComplete ? (osd.isCorrect ? color9 : color7) : color2;
          return Wrap(children: [
            for (int i = 0; i < osd.answerUser.length - 1; i++)
              _buildUserWord(context, i, osd.answerUser, colorAnswer),
          ], runSpacing: dimen6, alignment: WrapAlignment.center);
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
