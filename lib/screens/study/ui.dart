import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/screens/object_study/ui.dart';
import 'package:project/screens/study/controller.dart';
import 'package:project/screens/study/data.dart';
import 'package:project/util/show_dialog_general.dart';
import 'package:project/util/variable.dart';
import 'package:project/widgets/icon_refresh.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';

class Study extends StatefulWidget {
  @override
  _StudyState createState() => _StudyState();
  static Widget withDependency({String label, StudyItem item}) {
    return StateNotifierProvider<StudyController, StudyData>(
        create: (_) => StudyController(item: item), child: Study(label: label));
  }

  const Study({this.label});
  final String label;
}

class _StudyState extends State<Study> {
  GestureDetector _tabShowDialog;
  @override
  Widget build(BuildContext context) {
    return context.select((StudyData dt) => dt.item.childIsClass)
        ? Scaffold(
            appBar: AppBar(
                actions: [
                  IconRefresh(
                    onPress: () => context.read<StudyController>().refreshStudy(),
                  )
                ],
                centerTitle: true,
                title: Text(unescape.convert(widget.label ?? 'Học tập'))),
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
                                  onRetry: () => context
                                      .read<StudyController>()
                                      .initStudy());
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
                          builder: (context, length, __) {
                            List<StudyItem> list =
                                context.select((StudyData dt) => dt.item.items);
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int i = 0; i < list.length; i++)
                                    _buildStudyItem(context, item: list[i]),
                                ]);
                          },
                        )
                      ],
                    ),
                  ))
        : ObjectStudy.withDependency(
            uri: context
                .select((StudyData dt) => dt.item.items)
                .map((e) => e.dataUri)
                .toList(),
            label: widget.label);
  }

  Widget _buildStudyItem(BuildContext context, {StudyItem item}) {
    return Container(
      decoration: BoxDecoration(color: Colors.blue.withAlpha(30)),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(unescape.convert(item.label),
            style: TextStyle(fontFamily: 'monospace')),
        SizedBox(height: 4),
        Row(children: [
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          Study.withDependency(label: item.label, item: item)));
            },
            child: Container(
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: Colors.grey),
                child: Text('XEM',
                    style: TextStyle(color: Colors.white, fontSize: 12))),
          )
        ])
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<StudyController>(context, listen: false).initStudy();
  }
}
