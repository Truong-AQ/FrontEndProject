import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/resources/colors.dart';
import 'package:project/resources/dimens.dart';
import 'package:project/screens/questions/pairing/controller.dart';
import 'package:project/screens/questions/pairing/data.dart';
import 'package:project/screens/test/data.dart';
import 'package:project/widgets/PlayAudio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

class Pairing extends StatelessWidget {
  static withDependency(Map<String, dynamic> data) {
    return StateNotifierProvider<PairingController, PairingData>(
        create: (_) => PairingController(data), child: Pairing());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 10),
            child: _buildSuggest(context,
                Provider.of<PairingData>(context, listen: false).suggest)),
        _buildLabel(
            context, Provider.of<PairingData>(context, listen: false).label),
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
        margin: EdgeInsets.only(top: 50),
        width: 200,
        height: 200,
        child: Image.network(suggest.data, fit: BoxFit.fill,
            loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            Provider.of<PairingController>(context).updateTime(DateTime.now());
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
    if (label == null || label == '') return Container(height: 70);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 20),
        padding: EdgeInsets.all(dimen12),
        decoration: BoxDecoration(border: Border.all()),
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
        margin: EdgeInsets.only(top: 30),
        padding: EdgeInsets.symmetric(horizontal: dimen3),
        child: Consumer<PairingData>(
          builder: (_, dt, __) {
            return Wrap(
                alignment: WrapAlignment.center,
                children: [
                  for (int i = 0; i < dt.answers.length; i++)
                    _buildWord(context, dt.answers[i], i),
                ],
                runSpacing: 27);
          },
        ));
  }

  Widget _buildWord(BuildContext context, AnswerChoice answer, int index) {
    if (answer == null) return SizedBox(width: 0);
    return GestureDetector(
      onTap: () {
        context.read<PairingController>().addAnswer(index);
      },
      child: answer.type == 'image'
          ? Container(
              width: 150,
              height: 150,
              child: Image.network(answer.data, fit: BoxFit.fill,
                  loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  Provider.of<PairingController>(context)
                      .updateTime(DateTime.now());
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
            )
          : Container(
              decoration: BoxDecoration(
                  color: Colors.pink.withAlpha(45),
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.symmetric(horizontal: dimen5),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: Text(answer.data,
                  style: TextStyle(
                      color: color2, fontSize: 17, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
    );
  }

  Widget _buildUserAnswer(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 40),
        child: Consumer<PairingData>(builder: (_, dt, __) {
          return Column(children: [
            for (int i = 0; i < dt.userAnswer.length; i += 2)
              Row(children: [
                _CellPairing(answer: dt.userAnswer[i], index: i),
                _CellPairing(answer: dt.userAnswer[i + 1], index: i)
              ]),
          ]);
        }));
  }
}

class _CellPairing extends StatelessWidget {
  _CellPairing({Key key, this.answer, this.index}) : super(key: key);

  final AnswerChoice answer;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<PairingController>().removeAnswer(index);
        },
        child: answer == null
            ? Container(
                margin: EdgeInsets.all(12),
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.greenAccent))
            : (answer.type == 'image'
                ? Container(
                    width: 150,
                    height: 150,
                    child: Image.network(answer.data, fit: BoxFit.fill,
                        loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        Provider.of<PairingController>(context)
                            .updateTime(DateTime.now());
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
                  )
                : Container(
                    margin: EdgeInsets.all(12),
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.greenAccent),
                    child: Text(answer.data,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'monospace')))),
      ),
    );
  }
}
