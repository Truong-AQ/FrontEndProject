import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/resources/strings.dart';
import 'package:project/resources/types.dart';
import 'package:project/screens/item_check/controller.dart';
import 'package:project/screens/item_check/data.dart';
import 'package:project/util/function/show_dialog_general.dart';
import 'package:project/util/variable.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ItemsCheck extends StatelessWidget {
  static Widget withDependency(
      {TypeItemChecker type,
      List checker,
      String resourceUri,
      String title,
      String titleSaveSuccess}) {
    return StateNotifierProvider<ItemsCheckController, ItemsCheckData>(
        create: (_) => ItemsCheckController(
            type: type, checker: checker, resourceUri: resourceUri)
          ..initItemCheck(),
        child: ItemsCheck(title: title, titleSaveSuccess: titleSaveSuccess));
  }

  ItemsCheck({this.title, this.titleSaveSuccess});
  final String title, titleSaveSuccess;
  GestureDetector _tabShowDialog;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title), centerTitle: true),
        body: !context.select((ItemsCheckData dt) => dt.init)
            ? Loading(backgroundColor: Colors.white)
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    _tabShowDialog = GestureDetector(
                        child: Container(),
                        onTap: () {
                          String error = context.read<ItemsCheckData>().error;
                          showDialogOfApp(context,
                              error: error,
                              onRetry: () => context
                                  .read<ItemsCheckController>()
                                  .initItemCheck());
                        }),
                    Selector<ItemsCheckData, int>(
                      selector: (_, dt) => dt.numOfError,
                      builder: (_, __, ___) {
                        Future.delayed(Duration(milliseconds: 500))
                            .then((_) => _tabShowDialog.onTap());
                        return Container();
                      },
                    ),
                    Selector<ItemsCheckData, int>(
                      selector: (_, dt) => dt.items.length,
                      builder: (context, l, _) {
                        return Column(
                            children: context
                                .select((ItemsCheckData dt) => dt.items)
                                .map((e) => _ItemCheck(item: e))
                                .toList());
                      },
                    ),
                    GestureDetector(
                      onTap: () async {
                        showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (_) => Loading());
                        bool ok = await context
                            .read<ItemsCheckController>()
                            .saveItem();
                        Navigator.pop(context);
                        if (ok)
                          showDialogOfApp(context, message: titleSaveSuccess);
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red.withAlpha(35),
                        ),
                        child: Text('Lưu',
                            style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 18,
                                color: Colors.black)),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ));
  }
}

// ignore: must_be_immutable
class _ItemCheck extends StatefulWidget {
  _ItemCheck({Key key, this.item, this.level = 1}) : super(key: key);
  final CheckItem item;
  int level;
  bool init = false;
  @override
  __ItemCheckState createState() => __ItemCheckState();
}

class __ItemCheckState extends State<_ItemCheck> {
  bool open = false;
  CheckItem get item => widget.item;
  String get typeItem => widget.item.type;
  int get level => widget.level;
  bool get init => widget.init;
  List<CheckItem> get listItem => item.items;
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
                      if (typeItem == 'class' && !init) {
                        showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (_) => Loading());
                        got = await context
                            .read<ItemsCheckController>()
                            .getItem(item.items, classUri: item.id);
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
                    onChanged: (bool newValue) {
                      context
                          .read<ItemsCheckController>()
                          .addOrRemoveCheck(item.id);
                      setState(() {
                        item.isCheck = newValue;
                      });
                    })
          ]),
        ),
        Visibility(
            visible: open,
            child: Column(
              children: listItem
                  .map((item) => _ItemCheck(item: item, level: 2))
                  .toList(),
            ))
      ],
    );
  }
}
