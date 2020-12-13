import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/resources/strings.dart';
import 'package:project/resources/types.dart';
import 'package:project/screens/doctor/group/controller.dart';
import 'package:project/screens/doctor/group/data.dart';
import 'package:project/screens/item_check/ui.dart';
import 'package:project/util/function/drawer.dart';
import 'package:project/util/function/show_dialog_general.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';

import 'package:project/widgets/icon_refresh.dart';

// ignore: must_be_immutable
class Group extends StatelessWidget {
  static Widget withDependency() {
    return StateNotifierProvider<GroupController, GroupData>(
        create: (_) => GroupController()..initGroup(), child: Group());
  }

  GestureDetector _tabShowDialog;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawerDoctor(context),
      appBar: AppBar(title: Text('Nhóm'), centerTitle: true, actions: [
        IconRefresh(),
      ]),
      floatingActionButton:
          FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
      body: !context.select((GroupData dt) => dt.init)
          ? Loading()
          : Selector<GroupData, int>(
              selector: (_, dt) => dt.items.length,
              builder: (context, l, _) {
                return Column(
                  children: [
                    SizedBox(height: 10),
                    _tabShowDialog = GestureDetector(
                        child: Container(),
                        onTap: () {
                          String error = context.read<GroupData>().error;
                          showDialogOfApp(context,
                              error: error,
                              onRetry: () =>
                                  context.read<GroupController>().initGroup());
                        }),
                    Selector<GroupData, int>(
                      selector: (_, dt) => dt.numOfError,
                      builder: (_, __, ___) {
                        Future.delayed(Duration(milliseconds: 500))
                            .then((_) => _tabShowDialog.onTap());
                        return Container();
                      },
                    ),
                    Column(
                        children: context
                            .select((GroupData dt) => dt.items)
                            .map((item) => _GroupUI(item: item))
                            .toList())
                  ],
                );
              },
            ),
    );
  }
}

class _GroupUI extends StatelessWidget {
  const _GroupUI({this.item});
  final GroupItem item;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showDialog(
            useRootNavigator: false,
            context: context,
            builder: (_) => Loading());
        bool got = await context.read<GroupController>().getChecker(item);
        Navigator.pop(context);
        if (!got) return;
        showDialog(
            useRootNavigator: false,
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 70, left: 20, right: 20),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ItemsCheck.withDependency(
                                        type: TypeItemChecker.TESTTAKER,
                                        title: item.data,
                                        titleSaveSuccess: saveSucess,
                                        checker: item.checker['test-taker'],
                                        resourceUri: item.dataUri)));
                          },
                          child: Container(
                              width: 320,
                              decoration: BoxDecoration(
                                  color: Colors.blue.withAlpha(50)),
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              child: Text('Chọn người làm bài cho nhóm',
                                  style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 14,
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal))),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ItemsCheck.withDependency(
                                        type: TypeItemChecker.TEST,
                                        title: item.data,
                                        titleSaveSuccess: saveSucess,
                                        checker: item.checker['test'],
                                        resourceUri: item.dataUri)));
                          },
                          child: Container(
                              width: 320,
                              decoration: BoxDecoration(
                                  color: Colors.blue.withAlpha(50)),
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              child: Text('Chọn bài giao cho nhóm',
                                  style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 14,
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal))),
                        ),
                        SizedBox(height: 15)
                      ],
                    ),
                  )
                ],
              );
            });
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.blue.withAlpha(30)),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Row(children: [
          Text(item.data, style: TextStyle(fontFamily: 'monospace')),
        ]),
      ),
    );
  }
}
