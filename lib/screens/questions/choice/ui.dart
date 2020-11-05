import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/resources/colors.dart';
import 'package:project/resources/dimens.dart';
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
            child: _PlayAudio(
                url: Provider.of<ChoiceData>(context, listen: false).audio)),
        _buildQuestion(context),
        _buildAnswer(context),
      ],
    );
  }

  Widget _buildQuestion(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 35, bottom: dimen1),
      padding: EdgeInsets.all(dimen12),
      decoration: BoxDecoration(border: Border.all()),
      child: Text(Provider.of<ChoiceData>(context, listen: false).label,
          style: TextStyle(
              color: color2, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget _buildAnswer(BuildContext context) {
    List<String> answers =
        Provider.of<ChoiceData>(context, listen: false).urlImg;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      child: Table(
        children: [
          for (int i = 0; i < answers.length; i += 2)
            TableRow(children: [
              _CellRow(url: answers[i]),
              _CellRow(url: answers[i + 1])
            ]),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _PlayAudio extends StatefulWidget {
  _PlayAudio({this.url, this.isPlay = false});
  final String url;
  bool isPlay;
  @override
  __PlayAudioState createState() => __PlayAudioState();
}

class __PlayAudioState extends State<_PlayAudio> {
  get isPlay => widget.isPlay;
  get url => widget.url;
  set isPlay(bool isPlay) => widget.isPlay = isPlay;

  AssetsAudioPlayer audioPlayer;
  @override
  void initState() {
    super.initState();
    audioPlayer = AssetsAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isPlay) {
          setState(() {
            isPlay = true;
          });
          audioPlayer.open(Audio.network(widget.url)).then((_) {
            setState(() {
              isPlay = false;
            });
          });
        }
      },
      child: isPlay
          ? Icon(Icons.pause, size: 35, color: Colors.green)
          : Icon(Icons.play_arrow, size: 35, color: Colors.green),
    );
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }
}

// ignore: must_be_immutable
class _CellRow extends StatefulWidget {
  _CellRow({this.url, this.choice = false});
  String url;
  bool choice;
  @override
  __CellRowState createState() => __CellRowState();
}

class __CellRowState extends State<_CellRow> {
  get url => widget.url;
  get choice => widget.choice;
  set choice(bool choice) => widget.choice = choice;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          choice = !choice;
        });
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 7, vertical: 8),
          child: Container(
              decoration: BoxDecoration(
                  border: choice
                      ? Border.all(color: Colors.green, width: 3)
                      : Border.all()),
              child: Image.network(url, fit: BoxFit.fill))),
    );
  }
}
