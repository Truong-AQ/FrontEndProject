import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PlayAudio extends StatefulWidget {
  PlayAudio({this.url, this.isPlay = false});
  final String url;
  bool isPlay;
  @override
  _PlayAudioState createState() => _PlayAudioState();
}

class _PlayAudioState extends State<PlayAudio> {
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
