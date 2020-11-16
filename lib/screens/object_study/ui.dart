import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
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
        appBar:
            AppBar(title: Text(widget.label ?? 'Học tập'), centerTitle: true),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Selector<ObjectStudyData, int>(
                selector: (_, dt) => dt.items.length,
                builder: (context, length, __) {
                  List<ObjectStudyItem> list =
                      context.select((ObjectStudyData dt) => dt.items);
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
        ));
  }

  Widget _buildStudyItem(BuildContext context, {ObjectStudyItem item}) {
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
            },
            child: Container(
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: Colors.grey),
                child: Text('XEM KẾT QUẢ',
                    style: TextStyle(color: Colors.white, fontSize: 12))),
          )
        ])
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ObjectStudyController>(context, listen: false).initObjectStudy();
  }
}
