import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
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
    return context.select((ObjectStudyData dt) => dt.process)
        ? Loading()
        : Container(
            margin: EdgeInsets.all(14),
            child: Selector<ObjectStudyData, int>(
              selector: (_, dt) => dt.items.length,
              builder: (context, length, _) {
                List<ObjectStudyItem> list =
                    context.select((ObjectStudyData dt) => dt.items);
                return Table(
                  children: [
                    for (int i = 0; i < length; i++)
                      if (i + 1 < length)
                        TableRow(children: [
                          _CellRow(item: list[i]),
                          _CellRow(item: list[i + 1])
                        ])
                      else
                        TableRow(
                            children: [_CellRow(item: list[i]), Container()])
                  ],
                );
              },
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
class _CellRow extends StatefulWidget {
  _CellRow({this.item});
  ObjectStudyItem item;
  @override
  __CellRowState createState() => __CellRowState();
}

class __CellRowState extends State<_CellRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150, height: 150,
      child: Image.network(widget.item.urlImg, fit: BoxFit.fill,
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
    );
  }
}
