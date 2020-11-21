import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/resources/strings.dart';
import 'package:project/screens/object_study/ui.dart';
import 'package:project/screens/study/controller.dart';
import 'package:project/screens/study/data.dart';
import 'package:project/util/function/show_dialog_general.dart';
import 'package:project/util/variable.dart';
import 'package:project/widgets/icon_refresh.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';

class Study extends StatefulWidget {
  @override
  _StudyState createState() => _StudyState();
  static Widget withDependency() {
    return StateNotifierProvider<StudyController, StudyData>(
        create: (context) => StudyController(), child: Study());
  }
}

class _StudyState extends State<Study> {
  GestureDetector _tabShowDialog;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          IconRefresh(
            onPress: () => context.read<StudyController>().initStudy(),
          )
        ], centerTitle: true, title: Text('Học tập')),
        body: context.select((StudyData dt) => dt.process)
            ? Loading()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    _tabShowDialog = GestureDetector(
                        child: Container(),
                        onTap: () {
                          String error = context.read<StudyData>().error;
                          showDialogOfApp(context,
                              error: error,
                              onRetry: () =>
                                  context.read<StudyController>().initStudy());
                        }),
                    Selector<StudyData, int>(
                      selector: (_, dt) => dt.numOfError,
                      builder: (_, __, ___) {
                        Future.delayed(Duration(milliseconds: 500))
                            .then((_) => _tabShowDialog.onTap());
                        return Container();
                      },
                    ),
                    SizedBox(height: 10),
                    Selector<StudyData, int>(
                      selector: (_, dt) => dt.item.items.length,
                      builder: (_, length, __) {
                        List<StudyItemData> list =
                            context.read<StudyData>().item.items;
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int i = 0; i < list.length; i++)
                                _StudyItem(item: list[i]),
                            ]);
                      },
                    )
                  ],
                ),
              ));
  }

  @override
  void initState() {
    super.initState();
    Provider.of<StudyController>(context, listen: false).initStudy();
  }
}

// ignore: must_be_immutable
class _StudyItem extends StatefulWidget {
  _StudyItem({Key key, this.item, this.level = 1}) : super(key: key);
  final StudyItemData item;
  int level;
  bool init = false;
  @override
  __StudyItemState createState() => __StudyItemState();
}

class __StudyItemState extends State<_StudyItem> {
  bool open = false;
  StudyItemData get item => widget.item;
  int get level => widget.level;
  bool get init => widget.init;
  List<StudyItemData> get listItem => item.items;
  set init(init) => widget.init = init;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.blue.withAlpha(30)),
          margin: level == 1
              ? EdgeInsets.all(10)
              : EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 30),
          padding: EdgeInsets.all(10),
          child: Row(children: [
            Text(unescape.convert(item.label),
                style: TextStyle(fontFamily: 'monospace')),
            Spacer(),
            GestureDetector(
              onTap: () async {
                List<String> listUri;
                if (level == 2 || (level == 1 && !init)) {
                  showDialog(
                      useRootNavigator: false,
                      context: context,
                      builder: (_) => Loading());
                  listUri = (await context
                          .read<StudyController>()
                          .getListStudyItem(item))
                      .map((e) => e.dataUri)
                      .toList();
                  Navigator.pop(context);
                }
                if (level == 1) {
                  if (!init)
                    setState(() {
                      open = !open;
                    });
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ObjectStudy.withDependency(
                              listUri: listUri, label: item.label)));
                }
              },
              child: Image.asset(level == 1
                  ? (open ? urlIconArrowDown : urlIconAdd)
                  : urlIconArrowRight),
            )
          ]),
        ),
        Visibility(
            visible: open,
            child: Column(
              children: listItem
                  .map((item) => _StudyItem(item: item, level: 2))
                  .toList(),
            ))
      ],
    );
  }
}
