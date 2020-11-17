import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/resources/strings.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';

import 'controller.dart';
import 'data.dart';

class ObjectStudy extends StatefulWidget {
  @override
  _ObjectStudyState createState() => _ObjectStudyState();
  static Widget withDependency({String label, List<String> uri}) {
    return StateNotifierProvider<ObjectStudyController, ObjectStudyData>(
        create: (_) => ObjectStudyController(listUri: uri),
        child: ObjectStudy(label: label));
  }

  const ObjectStudy({this.label});
  final String label;
}

class _ObjectStudyState extends State<ObjectStudy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Html(data: widget.label, style: {
        'body': Style(
            textAlign: TextAlign.center,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: FontSize(20.0))
      })),
      body: context.select((ObjectStudyData dt) => dt.process)
          ? Loading()
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(14),
                child: Selector<ObjectStudyData, int>(
                  selector: (_, dt) => dt.items.length,
                  builder: (context, length, _) {
                    List<ObjectStudyItem> list =
                        context.select((ObjectStudyData dt) => dt.items);
                    return Column(
                      children: [
                        for (int i = 0; i < length; i += 2)
                          Row(
                            children: [
                              _CellRow(item: list[i]),
                              Spacer(),
                              if (i + 1 < length) _CellRow(item: list[i + 1])
                            ],
                          )
                      ],
                    );
                  },
                ),
              ),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ObjectStudyController>(context, listen: false)
        .initObjectStudy();
  }
}

// ignore: must_be_immutable
class _CellRow extends StatelessWidget {
  _CellRow({this.item});
  ObjectStudyItem item;
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  @override
  Widget build(BuildContext context) {
    return FlipCard(
      onFlip: () async {
        audioPlayer
            .open(Audio.network(item.urlAudio, headers: {'Cookie': cookie}));
      },
      front: Container(
        decoration: BoxDecoration(border: Border.all()),
        width: (MediaQuery.of(context).size.width - 38) / 2,
        height: (MediaQuery.of(context).size.width - 38) / 2,
        child: Image.network(item.urlImg,
            fit: BoxFit.fill, headers: {'Cookie': cookie},
            loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
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
      ),
      back: Container(
        decoration: BoxDecoration(
            border: Border.all(), color: Colors.greenAccent.withAlpha(25)),
        width: (MediaQuery.of(context).size.width - 38) / 2,
        height: (MediaQuery.of(context).size.width - 38) / 2,
        child: Center(
          child: Text(item.label,
              style: TextStyle(fontFamily: 'monospace', fontSize: 16)),
        ),
      ),
    );
  }
}
