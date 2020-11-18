import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/resources/strings.dart';
import 'package:project/util/variable.dart';
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
          centerTitle: true,
          title: Text(
            unescape.convert(widget.label),
          )),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(15),
            child: Column(
              children: [
                for (int i = 0;
                    i < context.select((ObjectStudyData dt) => dt.items.length);
                    i += 2)
                  Container(
                    margin: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Selector<ObjectStudyData, ObjectStudyItem>(
                          selector: (_, dt) => dt.items[i],
                          builder: (_, item, __) {
                            return item == null
                                ? Container()
                                : _CellRow(item: item);
                          },
                        ),
                        Spacer(),
                        Selector<ObjectStudyData, ObjectStudyItem>(
                          selector: (_, dt) => dt.items[i + 1],
                          builder: (_, item, __) {
                            return item == null
                                ? Container()
                                : _CellRow(item: item);
                          },
                        )
                      ],
                    ),
                  )
              ],
            )),
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
        child: Image(
          image: AdvancedNetworkImage(item.urlImg, header: {'Cookie': cookie}),
          fit: BoxFit.fill,
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
          },
        ),
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
