import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import 'package:flutter_advanced_networkimage_2/transition.dart';
import 'package:project/resources/strings.dart';
import 'package:project/screens/test/data.dart';
import 'package:project/widgets/play_audio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/screens/questions/choice/controller.dart';
import 'package:project/screens/questions/choice/data.dart';

class Choice extends StatelessWidget {
  static withDependency(Map<String, dynamic> data) {
    return StateNotifierProvider<ChoiceController, ChoiceData>(
        create: (_) => ChoiceController(data), child: Choice());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 10),
            child: _buildSuggest(context,
                Provider.of<ChoiceData>(context, listen: false).suggest)),
        _buildLabel(
            context, Provider.of<ChoiceData>(context, listen: false).label),
        _buildAnswer(
            context, Provider.of<ChoiceData>(context, listen: false).answers)
      ],
    );
  }

  Widget _buildSuggest(BuildContext context, AnswerChoice suggest) {
    if (suggest == null) return Container();
    if (suggest.type == 'audio') return PlayAudio(url: suggest.data);
    if (suggest.type == 'image')
      return Container(
          margin: EdgeInsets.only(top: 50),
          width: 200,
          height: 200,
          child: TransitionToImage(
              enableRefresh: true,
              loadingWidget: Image.asset(urlIconLoadingImage),
              placeholder: Icon(Icons.refresh),
              image: AdvancedNetworkImage(suggest.data, useDiskCache: true,
                  loadedCallback: () {
                Provider.of<ChoiceController>(context, listen: false)
                    .updateTime(DateTime.now());
              }),
              fit: BoxFit.fill));
    return Container();
  }

  Widget _buildLabel(BuildContext context, String label) {
    if (label == null || label == '') return Container(height: 40);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        margin: EdgeInsets.only(top: 35, bottom: 59),
        padding: EdgeInsets.all(18.0),
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ),
    );
  }

  Widget _buildAnswer(BuildContext context, List<AnswerChoice> answers) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          for (int i = 0; i < answers.length; i += 2)
            Row(children: [
              _CellRow(answer: answers[i]),
              Spacer(),
              _CellRow(answer: answers[i + 1])
            ]),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _CellRow extends StatefulWidget {
  _CellRow({this.answer, this.choice = false});
  AnswerChoice answer;
  bool choice;
  @override
  __CellRowState createState() => __CellRowState();
}

class __CellRowState extends State<_CellRow> {
  AnswerChoice get answer => widget.answer;
  get choice => widget.choice;
  set choice(bool choice) => widget.choice = choice;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        bool add = context.read<ChoiceController>().addAnswer(answer);
        if (add)
          setState(() {
            choice = !choice;
          });
      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          width: (MediaQuery.of(context).size.width - 38) / 2,
          height: answer.type == 'image'
              ? (MediaQuery.of(context).size.width - 38) / 2
              : 40,
          child: Container(
              decoration: BoxDecoration(
                  color: answer.type == 'image'
                      ? Colors.transparent
                      : Colors.pink.withAlpha(30),
                  border: choice
                      ? Border.all(color: Colors.green)
                      : Border.all(color: Colors.white)),
              child: answer.type == 'image'
                  ? TransitionToImage(
                      enableRefresh: true,
                      loadingWidget: Image.asset(urlIconLoadingImage),
                      placeholder: Icon(Icons.refresh),
                      image: AdvancedNetworkImage(answer.data,
                          useDiskCache: true, loadedCallback: () {
                        Provider.of<ChoiceController>(context, listen: false)
                            .updateTime(DateTime.now());
                      }),
                      fit: BoxFit.fill)
                  : Container(
                      padding: EdgeInsets.all(10),
                      child: Text(answer.data,
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'monospace')),
                    ))),
    );
  }
}
