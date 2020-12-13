import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/resources/strings.dart';
import 'package:project/screens/doctor/new_test/ui.dart';
import 'package:project/util/variable.dart';
import 'data.dart';
import 'controller.dart';
import 'package:project/util/function/drawer.dart';
import 'package:project/util/function/show_dialog_general.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';

import 'package:project/widgets/icon_refresh.dart';

// ignore: must_be_immutable
class Test extends StatelessWidget {
  static Widget withDependency() {
    return StateNotifierProvider<TestController, TestData>(
        create: (_) => TestController()..initTest(), child: Test());
  }

  GestureDetector _tabShowDialog;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawerDoctor(context),
      appBar: AppBar(title: Text('Bài kiểm tra'), centerTitle: true, actions: [
        IconRefresh(onPress: () {
          context.read<TestController>().initTest();
        }),
      ]),
      floatingActionButton: FloatingActionButton(
          heroTag: 'test',
          onPressed: () async {
            await Navigator.push(contextHome,
                MaterialPageRoute(builder: (_) => NewTest.withDependency()));
            context.read<TestController>().initTest();
          },
          child: Icon(Icons.add)),
      body: !context.select((TestData dt) => dt.init)
          ? Loading()
          : SingleChildScrollView(
              child: Selector<TestData, int>(
                selector: (_, dt) => dt.items.length,
                builder: (context, l, _) {
                  return Column(
                    children: [
                      SizedBox(height: 10),
                      _tabShowDialog = GestureDetector(
                          child: Container(),
                          onTap: () {
                            String error = context.read<TestData>().error;
                            showDialogOfApp(context,
                                error: error,
                                onRetry: () =>
                                    context.read<TestController>().initTest());
                          }),
                      Selector<TestData, int>(
                        selector: (_, dt) => dt.numOfError,
                        builder: (_, __, ___) {
                          Future.delayed(Duration(milliseconds: 500))
                              .then((_) => _tabShowDialog.onTap());
                          return Container();
                        },
                      ),
                      Column(
                          children: context
                              .select((TestData dt) => dt.items)
                              .map((item) => _TestUI(item: item))
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
class _TestUI extends StatefulWidget {
  _TestUI({Key key, this.item, this.level = 1}) : super(key: key);
  final TestItem item;
  int level;
  bool init = false;
  @override
  _TestUIState createState() => _TestUIState();
}

class _TestUIState extends State<_TestUI> {
  bool open = false;
  TestItem get item => widget.item;
  String get typeItem => widget.item.type;
  int get level => widget.level;
  bool get init => widget.init;
  List<TestItem> get listItem => item.items;
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
                            .read<TestController>()
                            .getTest(item.items, classUri: item.dataUri);
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
                  .map((item) => _TestUI(item: item, level: 2))
                  .toList(),
            ))
      ],
    );
  }
}
