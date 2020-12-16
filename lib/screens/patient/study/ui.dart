import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/resources/strings.dart';
import 'package:project/screens/patient/object_study/ui.dart';
import 'package:project/screens/patient/study/controller.dart';
import 'package:project/screens/patient/study/data.dart';
import 'package:project/util/function/drawer.dart';
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
        drawer: buildDrawerPatient(context),
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
          decoration: BoxDecoration(
              color: Colors.blue.withAlpha(30),
              borderRadius: BorderRadius.circular(10)),
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
                bool got = false;
                if (level == 2 || (level == 1 && !init)) {
                  showDialog(
                      useRootNavigator: false,
                      context: context,
                      builder: (_) => Loading());
                  got = (await context
                      .read<StudyController>()
                      .getListStudyItem(item));
                  if (level == 1) init = got;
                  Navigator.pop(context);
                }
                if (level == 1) {
                  setState(() {
                    open = !open;
                  });
                } else {
                  if (got) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ObjectStudy.withDependency(
                                listUri: item.items
                                    .map((item) => item.dataUri)
                                    .toList(),
                                label: item.label)));
                  }
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
