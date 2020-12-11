import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/resources/strings.dart';
import 'package:project/screens/doctor/register_patient/ui.dart';
import 'package:project/util/variable.dart';
import 'data.dart';
import 'controller.dart';
import 'package:project/util/function/drawer.dart';
import 'package:project/util/function/show_dialog_general.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';

import 'package:project/widgets/icon_refresh.dart';

// ignore: must_be_immutable
class TestTaker extends StatelessWidget {
  static Widget withDependency() {
    return StateNotifierProvider<TestTakerController, TestTakerData>(
        create: (_) => TestTakerController()..initTestTaker(),
        child: TestTaker());
  }

  GestureDetector _tabShowDialog;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawerDoctor(context),
      appBar: AppBar(title: Text('Người làm bài'), centerTitle: true, actions: [
        IconRefresh(),
      ]),
      floatingActionButton: FloatingActionButton(
          heroTag: 'test-taker',
          onPressed: () {
            Navigator.push(
                contextHome,
                MaterialPageRoute(
                    builder: (_) => RegisterPatient.withDependency()));
          },
          child: Icon(Icons.add)),
      body: !context.select((TestTakerData dt) => dt.init)
          ? Loading()
          : SingleChildScrollView(
              child: Selector<TestTakerData, int>(
                selector: (_, dt) => dt.items.length,
                builder: (context, l, _) {
                  return Column(
                    children: [
                      SizedBox(height: 10),
                      _tabShowDialog = GestureDetector(
                          child: Container(),
                          onTap: () {
                            String error = context.read<TestTakerData>().error;
                            showDialogOfApp(context,
                                error: error,
                                onRetry: () => context
                                    .read<TestTakerController>()
                                    .initTestTaker());
                          }),
                      Selector<TestTakerData, int>(
                        selector: (_, dt) => dt.numOfError,
                        builder: (_, __, ___) {
                          Future.delayed(Duration(milliseconds: 500))
                              .then((_) => _tabShowDialog.onTap());
                          return Container();
                        },
                      ),
                      Column(
                          children: context
                              .select((TestTakerData dt) => dt.items)
                              .map((item) => _TestTakerUI(item: item))
                              .toList())
                    ],
                  );
                },
              ),
            ),
    );
  }
}

// ignore: must_be_immutable
class _TestTakerUI extends StatefulWidget {
  _TestTakerUI({Key key, this.item, this.level = 1}) : super(key: key);
  final TesttakerItem item;
  int level;
  bool init = false;
  @override
  __TestTakerUIState createState() => __TestTakerUIState();
}

class __TestTakerUIState extends State<_TestTakerUI> {
  bool open = false;
  TesttakerItem get item => widget.item;
  String get typeItem => widget.item.type;
  int get level => widget.level;
  bool get init => widget.init;
  List<TesttakerItem> get listItem => item.items;
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
            Text(unescape.convert(item.data),
                style: TextStyle(fontFamily: 'monospace')),
            Spacer(),
            typeItem == 'class'
                ? GestureDetector(
                    child: Image.asset(open ? urlIconArrowDown : urlIconAdd),
                    onTap: () async {
                      bool got = true;
                      if (typeItem == 'class' && !init) {
                        showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (_) => Loading());
                        got = await context
                            .read<TestTakerController>()
                            .getTestTaker(item.items, classUri: item.dataUri);
                        Navigator.pop(context);
                        init = got;
                      }
                      if (init) {
                        setState(() {
                          open = !open;
                        });
                      }
                    })
                : Container()
          ]),
        ),
        Visibility(
            visible: open,
            child: Column(
              children: listItem
                  .map((item) => _TestTakerUI(item: item, level: 2))
                  .toList(),
            ))
      ],
    );
  }
}
