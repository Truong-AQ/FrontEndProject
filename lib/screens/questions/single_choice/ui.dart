import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/resources/colors.dart';
import 'package:project/resources/dimens.dart';
import 'package:project/resources/styles.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:project/screens/login/controller.dart';
import 'package:project/screens/login/data.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

class SingleChoice extends StatelessWidget {
  static withDependency() {
    return StateNotifierProvider<LoginController, LoginData>(
        create: (_) => LoginController(), child: SingleChoice());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: color8,
            title: Text('BAI TAP',
                style: TextStyle(
                    fontSize: dimen12,
                    color: color2,
                    fontWeight: FontWeight.bold)),
            elevation: 0),
        body: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                  child: Column(
                children: [
                  _buildQuestion(context),
                  _buildAnswer(context),
                ],
              )),
            ),
          );
        }));
  }

  Widget _buildQuestion(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: dimen1, bottom: dimen1),
      padding: EdgeInsets.all(dimen12),
      decoration: BoxDecoration(border: Border.all()),
      child: Text('CAI AM NUOC',
          style: TextStyle(
              color: color2, fontWeight: FontWeight.bold, fontSize: dimen3)),
    );
  }

  Widget _buildAnswer(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          _buildCellRow(Icon(Icons.home, size: dimen13)),
          _buildCellRow(Icon(Icons.home, size: dimen13))
        ]),
        TableRow(children: [
          _buildCellRow(Icon(Icons.home, size: dimen13)),
          _buildCellRow(Icon(Icons.home, size: dimen13))
        ])
      ],
    );
  }

  Widget _buildCellRow(Widget child) {
    return Container(padding: EdgeInsets.all(dimen12), child: child);
  }
}
