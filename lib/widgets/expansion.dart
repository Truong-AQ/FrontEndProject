import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Expansion extends StatefulWidget {
  Expansion({this.title, this.body, this.showBody = false});
  Widget title, body;
  bool showBody;
  @override
  _ExpansionState createState() => _ExpansionState();
}

class _ExpansionState extends State<Expansion> {
  get title => widget.title;
  get body => widget.body;
  get showBody => widget.showBody;
  set showBody(bool val) => widget.showBody = val;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        child: title,
        onTap: () {
          setState(() {
            showBody = !showBody;
          });
        },
      ),
      Visibility(child: body, visible: showBody)
    ]);
  }
}
