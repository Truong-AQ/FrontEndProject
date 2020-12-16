import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/resources/strings.dart';
import 'package:project/util/variable.dart';
import 'controller.dart';
import 'data.dart';
import 'package:project/screens/patient/result_attempt/ui.dart';
import 'package:project/util/function/drawer.dart';
import 'package:project/util/function/show_dialog_general.dart';
import 'package:project/widgets/icon_refresh.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
  static Widget withDependency() {
    return StateNotifierProvider<ResultController, ResultData>(
        create: (_) => ResultController(), child: Result());
  }
}

class _ResultState extends State<Result> {
  GestureDetector _tabShowDialog;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: buildDrawerDoctor(context),
        appBar: AppBar(title: Text('Kết quả'), centerTitle: true, actions: [
          IconRefresh(
              onPress: () => context.read<ResultController>().initResult())
        ]),
        body: Selector<ResultData, bool>(
          selector: (_, dt) => dt.process,
          builder: (_, process, __) {
            if (process) return Loading();
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Selector<ResultData, int>(
                    selector: (_, dt) => dt.result.length,
                    builder: (context, length, __) {
                      List<ResultTest> list =
                          context.select((ResultData dt) => dt.result);
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < list.length; i++)
                              _ResultItem(item: list[i]),
                          ]);
                    },
                  ),
                  _tabShowDialog = GestureDetector(
                      child: Container(),
                      onTap: () {
                        String error = context.read<ResultData>().error;
                        showDialogOfApp(context,
                            error: error,
                            onRetry: () =>
                                context.read<ResultController>().initResult());
                      }),
                  Selector<ResultData, int>(
                    selector: (_, dt) => dt.numOfError,
                    builder: (_, __, ___) {
                      Future.delayed(Duration(milliseconds: 500))
                          .then((_) => _tabShowDialog.onTap());
                      return Container();
                    },
                  )
                ],
              ),
            );
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ResultController>(context, listen: false).initResult();
  }
}

// ignore: must_be_immutable
class _ResultItem extends StatefulWidget {
  _ResultItem({Key key, this.item, this.level = 1}) : super(key: key);
  final ResultTest item;
  int level;
  bool init = false;
  @override
  _ResultItemState createState() => _ResultItemState();
}

class _ResultItemState extends State<_ResultItem> {
  bool open = false;
  ResultTest get item => widget.item;
  String get typeItem => widget.item.type;
  int get level => widget.level;
  bool get init => widget.init;
  List<ResultTest> get listItem => item.items;

  set init(init) => widget.init = init;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
          ),
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
                            .read<ResultController>()
                            .getResult(item.items, classUri: item.dataUri);
                        Navigator.pop(context);
                        init = got;
                      }
                      if (init) {
                        setState(() {
                          open = !open;
                        });
                      }
                    })
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ResultTestTime.withDependency(
                                  listTestTaker: [],
                                  dataUri: item.dataUri,
                                  label: item.data)));
                    },
                    child: Container(
                        padding: EdgeInsets.all(7),
                        margin: EdgeInsets.only(bottom: 10, top: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey),
                        child: Text('XEM KẾT QUẢ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12))),
                  )
          ]),
        ),
        Visibility(
            visible: open,
            child: Column(
              children: listItem
                  .map((item) => _ResultItem(item: item, level: 2))
                  .toList(),
            ))
      ],
    );
  }
}
