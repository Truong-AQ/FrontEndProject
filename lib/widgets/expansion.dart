import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:project/resources/dimens.dart';
import 'package:project/resources/styles.dart';
import 'package:project/resources/types.dart';

// ignore: must_be_immutable
class Expansion extends StatefulWidget {
  Expansion(
      {this.label,
      this.isQuestion = false,
      this.body,
      this.showBody = false,
      this.marginLeft,
      this.generateBody});
  Widget body;
  bool isQuestion;
  String label;
  bool showBody;
  double marginLeft;
  CreateWidget generateBody;
  @override
  _ExpansionState createState() => _ExpansionState();
}

class _ExpansionState extends State<Expansion> {
  String get label => widget.label;
  Widget get body => widget.body;
  set body(Widget val) => widget.body = val;
  bool get showBody => widget.showBody;
  double get marginLeft => widget.marginLeft;
  set showBody(bool val) => widget.showBody = val;
  CreateWidget get generateBody => widget.generateBody;
  bool get isNodeQuestion => widget.isQuestion;
  @override
  Widget build(BuildContext context) {
    return isNodeQuestion
        ? Container(
            decoration: style7,
            alignment: Alignment.topLeft,
            margin:
                EdgeInsets.only(bottom: dimen12, left: marginLeft, right: 12),
            padding: EdgeInsets.all(dimen5),
            child: Html(
              data: label,
              style: {"body": style6},
            ),
          )
        : Column(children: [
            GestureDetector(
              child: Container(
                  decoration: style7,
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(
                      bottom: dimen12, left: marginLeft, right: 12),
                  padding: EdgeInsets.all(dimen5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Html(
                          data: label,
                          style: {"body": style6},
                        ),
                      ),
                      showBody
                          ? Icon(Icons.arrow_downward,
                              size: 18, color: Colors.black)
                          : Icon(Icons.arrow_upward,
                              size: 18, color: Colors.black)
                    ],
                  )),
              onTap: () async {
                if (body == null) body = await generateBody();
                setState(() {
                  showBody = !showBody;
                });
              },
            ),
            Visibility(child: body ?? Container(), visible: showBody)
          ]);
  }
}
