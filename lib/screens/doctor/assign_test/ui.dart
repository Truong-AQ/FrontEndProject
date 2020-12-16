import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/resources/strings.dart';
import 'package:project/screens/doctor/new_assign_test/ui.dart';
import 'package:project/util/variable.dart';
import 'data.dart';
import 'controller.dart';
import 'package:project/util/function/drawer.dart';
import 'package:project/util/function/show_dialog_general.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';

import 'package:project/widgets/icon_refresh.dart';

// ignore: must_be_immutable
class AssignTest extends StatelessWidget {
  static Widget withDependency() {
    return StateNotifierProvider<AssignTestController, AssignTestData>(
        create: (_) => AssignTestController()..initTest(), child: AssignTest());
  }

  GestureDetector _tabShowDialog;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawerDoctor(context),
      appBar: AppBar(title: Text('Bài kiểm tra'), centerTitle: true, actions: [
        IconRefresh(onPress: () {
          context.read<AssignTestController>().initTest();
        }),
      ]),
      floatingActionButton: FloatingActionButton(
          heroTag: 'new_test',
          onPressed: () async {
            await Navigator.push(
                contextHome,
                MaterialPageRoute(
                    builder: (_) => NewAssignTest.withDependency()));
            context.read<AssignTestController>().initTest();
          },
          child: Icon(Icons.add)),
      body: !context.select((AssignTestData dt) => dt.init)
          ? Loading()
          : SingleChildScrollView(
              child: Selector<AssignTestData, int>(
                selector: (_, dt) => dt.items.length,
                builder: (context, l, _) {
                  return Column(
                    children: [
                      SizedBox(height: 10),
                      _tabShowDialog = GestureDetector(
                          child: Container(),
                          onTap: () {
                            String error = context.read<AssignTestData>().error;
                            showDialogOfApp(context,
                                error: error,
                                onRetry: () => context
                                    .read<AssignTestController>()
                                    .initTest());
                          }),
                      Selector<AssignTestData, int>(
                        selector: (_, dt) => dt.numOfError,
                        builder: (_, __, ___) {
                          Future.delayed(Duration(milliseconds: 500))
                              .then((_) => _tabShowDialog.onTap());
                          return Container();
                        },
                      ),
                      Column(
                          children: context
                              .select((AssignTestData dt) => dt.items)
                              .map((item) => _AssignTestUI(item: item))
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
class _AssignTestUI extends StatefulWidget {
  _AssignTestUI({Key key, this.item, this.level = 1}) : super(key: key);
  final AssignTestItem item;
  int level;
  bool init = false;
  @override
  _AssignTestUIState createState() => _AssignTestUIState();
}

class _AssignTestUIState extends State<_AssignTestUI> {
  bool open = false;
  AssignTestItem get item => widget.item;
  String get typeItem => widget.item.type;
  int get level => widget.level;
  bool get init => widget.init;
  List<AssignTestItem> get listItem => item.items;
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
                            .read<AssignTestController>()
                            .getAssignTest(item.items, classUri: item.dataUri);
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
                  .map((item) => _AssignTestUI(item: item, level: 2))
                  .toList(),
            ))
      ],
    );
  }
}
