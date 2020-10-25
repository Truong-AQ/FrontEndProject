import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/resources/strings.dart';
import 'package:project/util/function/show_dialog_general.dart';
import 'package:project/util/variable.dart';
import 'package:project/widgets/icon_refresh.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';

import 'controller.dart';
import 'data.dart';

class ObjectStudy extends StatefulWidget {
  @override
  _ObjectStudyState createState() => _ObjectStudyState();
  static Widget withDependency({String label, List<String> listUri}) {
    return StateNotifierProvider<ObjectStudyController, ObjectStudyData>(
        create: (_) => ObjectStudyController(listUri: listUri),
        child: ObjectStudy(label: label));
  }

  const ObjectStudy({this.label});
  final String label;
}

class _ObjectStudyState extends State<ObjectStudy> {
  GestureDetector _tabShowDialog;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconRefresh(
              onPress: () =>
                  context.read<ObjectStudyController>().refreshObjectStudy(),
            )
          ],
          centerTitle: true,
          title: Text(
            unescape.convert(widget.label),
          )),
      body: context.select((ObjectStudyData dt) => dt.init)
          ? SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      _tabShowDialog = GestureDetector(
                          child: Container(),
                          onTap: () {
                            String error =
                                context.read<ObjectStudyData>().error;
                            showDialogOfApp(context,
                                error: error,
                                onRetry: () => context
                                    .read<ObjectStudyController>()
                                    .initObjectStudy());
                          }),
                      Selector<ObjectStudyData, int>(
                        selector: (_, dt) => dt.numOfError,
                        builder: (_, __, ___) {
                          Future.delayed(Duration(milliseconds: 500))
                              .then((_) => _tabShowDialog.onTap());
                          return Container();
                        },
                      ),
                      for (int i = 0;
                          i <
                              context.select(
                                  (ObjectStudyData dt) => dt.items.length);
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
            )
          : Loading(),
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
        child: TransitionToImage(
            enableRefresh: true,
            placeholder: Icon(Icons.refresh),
            loadingWidget: Image.asset(urlIconLoadingImage),
            image: AdvancedNetworkImage(item.urlImg,
                useDiskCache: true, header: {'Cookie': cookie}),
            fit: BoxFit.fill),
      ),
      back: Container(
        decoration: BoxDecoration(
            border: Border.all(), color: Colors.greenAccent.withAlpha(25)),
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: (MediaQuery.of(context).size.width - 38) / 2,
        height: (MediaQuery.of(context).size.width - 38) / 2,
        child: Center(
          child: Text(item.label,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'monospace', fontSize: 16)),
        ),
      ),
    );
  }
}
