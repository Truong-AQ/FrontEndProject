import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/resources/strings.dart';
import 'package:project/util/variable.dart';
import 'data.dart';
import 'controller.dart';
import 'package:project/util/function/show_dialog_general.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';

import 'package:project/widgets/icon_refresh.dart';

// ignore: must_be_immutable
class ChooseItemUI extends StatelessWidget {
  static Widget withDependency({String uri}) {
    return StateNotifierProvider<ChooseItemController, ChooseItemData>(
        create: (_) => ChooseItemController(uri: uri)..initTest(),
        child: ChooseItemUI());
  }

  GestureDetector _tabShowDialog;
  IconButton saveBT;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chọn câu hỏi'), centerTitle: true, actions: [
        IconRefresh(onPress: () {
          context.read<ChooseItemController>().initTest();
        }),
        saveBT = IconButton(
            icon: Icon(Icons.verified),
            onPressed: () async {
              showDialog(context: context, builder: (_) => Loading());
              String error =
                  await context.read<ChooseItemController>().saveQuestions();
              Navigator.pop(context);
              if (error == '') {
                showDialogOfApp(context,
                    message: createTestSuccess,
                    onRetry: () => Future.delayed(Duration(milliseconds: 500))
                        .then((_) => saveBT.onPressed()));
                return;
              }
              showDialogOfApp(context,
                  error: error,
                  onRetry: () => Future.delayed(Duration(milliseconds: 500))
                      .then((_) => saveBT.onPressed()));
            })
      ]),
      body: !context.select((ChooseItemData dt) => dt.init)
          ? Loading()
          : SingleChildScrollView(
              child: Selector<ChooseItemData, int>(
                selector: (_, dt) => dt.items.length,
                builder: (context, l, _) {
                  return Column(
                    children: [
                      SizedBox(height: 10),
                      _tabShowDialog = GestureDetector(
                          child: Container(),
                          onTap: () {
                            String error = context.read<ChooseItemData>().error;
                            showDialogOfApp(context,
                                error: error,
                                onRetry: () => context
                                    .read<ChooseItemController>()
                                    .initTest());
                          }),
                      Selector<ChooseItemData, int>(
                        selector: (_, dt) => dt.numOfError,
                        builder: (_, __, ___) {
                          Future.delayed(Duration(milliseconds: 500))
                              .then((_) => _tabShowDialog.onTap());
                          return Container();
                        },
                      ),
                      Column(
                          children: context
                              .select((ChooseItemData dt) => dt.items)
                              .map((item) => _ChooseItemDataUI(item: item))
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
class _ChooseItemDataUI extends StatefulWidget {
  _ChooseItemDataUI({Key key, this.item, this.level = 1}) : super(key: key);
  final ChooseItem item;
  int level;
  bool init = false;
  @override
  _ChooseItemDataUIState createState() => _ChooseItemDataUIState();
}

class _ChooseItemDataUIState extends State<_ChooseItemDataUI> {
  bool open = false;
  ChooseItem get item => widget.item;
  String get typeItem => widget.item.type;
  int get level => widget.level;
  bool get init => widget.init;
  List<ChooseItem> get listItem => item.items;
  set init(init) => widget.init = init;
  List<Widget> child;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: level == 1
                  ? Color.fromARGB(79, 92, 242, 134)
                  : (level == 2
                      ? Color(0xffCFDBFF)
                      : (level == 3
                          ? Color(0xffE5E5E5)
                          : (level == 4
                              ? Color(0xFFFF0633).withAlpha(33)
                              : Color(0xff55AFF6).withAlpha(48)))),
              borderRadius: BorderRadius.circular(10)),
          margin: level == 1
              ? EdgeInsets.all(10)
              : EdgeInsets.only(
                  top: 5, bottom: 5, right: 10, left: 10 + (level - 1) * 20.0),
          padding: typeItem == 'class'
              ? EdgeInsets.all(10)
              : EdgeInsets.only(left: 10),
          child: Row(children: [
            Text(unescape.convert(item.data),
                style: TextStyle(fontFamily: 'monospace')),
            Spacer(),
            typeItem == 'class'
                ? GestureDetector(
                    child: Image.asset(open ? urlIconArrowDown : urlIconAdd),
                    onTap: () async {
                      bool got = true;
                      if (listItem.isNotEmpty) init = true;
                      if (typeItem == 'class' && !init) {
                        showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (_) => Loading());
                        got = await context
                            .read<ChooseItemController>()
                            .getItems(item.items, classUri: item.uri);
                        Navigator.pop(context);
                        init = got;
                      }
                      if (init) {
                        setState(() {
                          open = !open;
                        });
                      }
                    })
                : Checkbox(
                    value: item.isCheck,
                    onChanged: (newValue) {
                      setState(() {
                        context
                            .read<ChooseItemController>()
                            .addOrRemoveCheck(item);
                      });
                    })
          ]),
        ),
        Visibility(
            visible: open,
            child: Column(
              children: listItem
                  .map(
                      (item) => _ChooseItemDataUI(item: item, level: level + 1))
                  .toList(),
            ))
      ],
    );
  }
}
