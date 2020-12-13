import 'package:flutter/material.dart';
import 'package:project/screens/doctor/choose_item/ui.dart';
import 'package:project/util/function/show_dialog_general.dart';
import 'package:project/util/variable.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'controller.dart';
import 'data.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

// ignore: must_be_immutable
class NewTest extends StatelessWidget {
  GestureDetector _tabShowDialog;
  static withDependency() {
    return StateNotifierProvider<NewTestController, NewTestData>(
        create: (context) {
          contextLogin = context;
          return NewTestController();
        },
        child: NewTest());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Kiểm tra mới'), centerTitle: true),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 100),
              Text('Tên bài test là',
                  style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  onChanged: (name) {
                    context.read<NewTestController>().setName(name);
                  },
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 30),
              _tabShowDialog = GestureDetector(
                onTap: () async {
                  showDialog(context: context, builder: (_) => Loading());
                  String error =
                      await context.read<NewTestController>().createTest();
                  Navigator.pop(context);
                  if (error == '') {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChooseItemUI.withDependency(
                                uri: context.read<NewTestData>().uri)));
                    return;
                  }
                  showDialogOfApp(context,
                      error: error,
                      onRetry: () => Future.delayed(Duration(milliseconds: 500))
                          .then((_) => _tabShowDialog.onTap()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.pink.withAlpha(40),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text('Lưu',
                      style: TextStyle(fontFamily: 'monospace', fontSize: 24)),
                ),
              )
            ],
          ),
        ));
  }
}
