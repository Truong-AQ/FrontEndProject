import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/screens/object_study/ui.dart';
import 'package:project/screens/study/controller.dart';
import 'package:project/screens/study/data.dart';
import 'package:provider/provider.dart';

class Study extends StatefulWidget {
  @override
  _StudyState createState() => _StudyState();
  static Widget withDependency({String classUri, String label}) {
    return StateNotifierProvider<StudyController, StudyData>(
        create: (_) => StudyController(classUri: classUri),
        child: Study(label: label));
  }

  const Study({this.label});
  final String label;
}

class _StudyState extends State<Study> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(widget.label ?? 'Học tập'), centerTitle: true),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Selector<StudyData, int>(
                selector: (_, dt) => dt.items.length,
                builder: (context, length, __) {
                  List<StudyItem> list =
                      context.select((StudyData dt) => dt.items);
                  return context.select((StudyData dt) => dt.childIsClass)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              for (int i = 0; i < list.length; i++)
                                _buildStudyItem(context, item: list[i]),
                            ])
                      : ObjectStudy.withDependency(
                          uri: list.map((e) => e.dataUri).toList());
                },
              )
            ],
          ),
        ));
  }

  Widget _buildStudyItem(BuildContext context, {StudyItem item}) {
    return Container(
      decoration: BoxDecoration(color: Colors.blue.withAlpha(30)),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(item.label, style: TextStyle(fontFamily: 'monospace')),
        SizedBox(height: 4),
        Row(children: [
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Study.withDependency(
                          classUri: item.dataUri, label: item.label)));
            },
            child: Container(
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: Colors.grey),
                child: Text('CHỦ ĐỀ CON',
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
