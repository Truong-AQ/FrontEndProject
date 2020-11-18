import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
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
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 10),
            child: _buildSuggest(
                context,
                Provider.of<OrderSentenceData>(context, listen: false)
                    .suggest)),
        _buildLabel(context,
            Provider.of<OrderSentenceData>(context, listen: false).label),
        _buildAnswer(context),
        _buildUserAnswer(context)
      ],
    );
  }

  Widget _buildSuggest(BuildContext context, AnswerChoice suggest) {
    if (suggest == null) return Container();
    if (suggest.type == 'audio') return PlayAudio(url: suggest.data);
    if (suggest.type == 'image')
      return Container(
          width: 200,
          height: 200,
          child: TransitionToImage(
              enableRefresh: true,
              image: AdvancedNetworkImage(suggest.data, loadedCallback: () {
                Provider.of<OrderSentenceController>(context)
                    .updateTime(DateTime.now());
              }),
              fit: BoxFit.fill));
    return Container();
  }

  Widget _buildLabel(BuildContext context, String label) {
    if (label == null || label == '') return Container();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        margin: EdgeInsets.only(top: 35, bottom: 35),
        padding: EdgeInsets.all(dimen12),
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: color2, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Widget _buildAnswer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: dimen3),
      child: Consumer<OrderSentenceData>(builder: (_, dt, __) {
        return Wrap(
            alignment: WrapAlignment.center,
            children: [
              for (int i = 0; i < dt.answers.length; i++)
                _buildWord(context, dt.answers[i], i),
            ],
            runSpacing: dimen6);
      }),
    );
  }

  Widget _buildWord(BuildContext context, AnswerChoice answer, int index) {
    if (answer == null) return SizedBox(width: 0);
    return GestureDetector(
      onTap: () {
        context.read<OrderSentenceController>().addAnswer(index);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: dimen5),
        width: dimen6 * answer.data.length,
        child: Text(answer.data,
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
        padding:
            EdgeInsets.only(left: dimen3, right: dimen3, top: 45, bottom: 45),
        child: Consumer<OrderSentenceData>(builder: (_, dt, __) {
          List<AnswerChoice> userAnswer = dt.userAnswer;
          return Wrap(children: [
            for (int i = 0; i < userAnswer.length; i++)
              _buildUserWord(context, i, userAnswer[i]),
          ], runSpacing: dimen6, alignment: WrapAlignment.center);
        }));
  }

  Widget _buildUserWord(BuildContext context, int index, AnswerChoice answer) {
    return Container(
        height: dimen8,
        margin: EdgeInsets.symmetric(horizontal: dimen5),
        padding: EdgeInsets.only(bottom: dimen18),
        alignment: Alignment.center,
        width: answer == null ? dimen17 : answer.data.length * dimen6,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: dimen16)),
        ),
        child: answer == null
            ? Container()
            : GestureDetector(
                onTap: () {
                  context.read<OrderSentenceController>().removeAnswer(index);
                },
                child: Text(answer.data,
                    style: TextStyle(
                        fontSize: dimen12, fontWeight: FontWeight.bold)),
              ));
  }
}
