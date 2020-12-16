import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:project/resources/strings.dart';
import 'package:project/resources/types.dart';
import 'package:project/screens/item_check/ui.dart';
import 'package:project/util/function/show_dialog_general.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'controller.dart';
import 'data.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

// ignore: must_be_immutable
class NewAssignTest extends StatelessWidget {
  GestureDetector _tabShowDialog;
  static withDependency() {
    return StateNotifierProvider<NewAssignTestController, NewAssignTestData>(
        create: (_) => NewAssignTestController(), child: NewAssignTest());
  }

  TextEditingController timeStartController = TextEditingController(),
      timeEndController = TextEditingController(),
      nameTestController = TextEditingController();

  List<String> suggestions = [];
  @override
  Widget build(BuildContext context) {
    context.watch<NewAssignTestController>().searchTest(suggestions, '');
    return Scaffold(
        appBar: AppBar(title: Text('Giao kiểm tra mới'), centerTitle: true),
        body: _buildNewAssignTestForm(context));
  }

  Widget _buildNewAssignTestForm(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        child: Column(
          children: [
            SizedBox(height: 25),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0),
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'Tiêu đề'),
                  onChanged: (title) {
                    context.read<NewAssignTestController>().setTitle(title);
                  },
                )),
            SizedBox(height: 25),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0),
                child: TextFormField(
                  decoration:
                      InputDecoration(hintText: 'Số lần thực hiện nhiều nhất'),
                  onChanged: (maxExec) {
                    context.read<NewAssignTestController>().setMaxExec(maxExec);
                  },
                )),
            SizedBox(height: 25),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0),
                child: TextFormField(
                    controller: timeStartController,
                    decoration: InputDecoration(hintText: 'Thời gian bắt đầu'),
                    onTap: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true, onConfirm: (timeStart) {
                        timeStartController.text = '$timeStart';
                        context
                            .read<NewAssignTestController>()
                            .setTimeStart(timeStartController.text);
                      }, currentTime: DateTime.now(), locale: LocaleType.vi);
                    })),
            SizedBox(height: 25),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0),
                child: TextFormField(
                    controller: timeEndController,
                    onTap: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true, onConfirm: (timeEnd) {
                        timeEndController.text = '$timeEnd';
                        context
                            .read<NewAssignTestController>()
                            .setTimeEnd(timeEndController.text);
                      }, currentTime: DateTime.now(), locale: LocaleType.vi);
                    },
                    decoration:
                        InputDecoration(hintText: 'Thời gian kết thúc'))),
            SizedBox(height: 25),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0),
                child: SimpleAutoCompleteTextField(
                  controller: nameTestController,
                  suggestionsAmount: 15,
                  decoration:
                      InputDecoration(hintText: 'Chọn bài kiểm tra để giao'),
                  suggestions: suggestions,
                  textChanged: (_) {},
                  clearOnSubmit: false,
                  textSubmitted: (_) {},
                  key: key,
                )),
            SizedBox(height: 40),
            _tabShowDialog = GestureDetector(
              onTap: () async {
                showDialog(context: context, builder: (_) => Loading());
                String error = await context
                    .read<NewAssignTestController>()
                    .assignTest(suggestions.indexOf(nameTestController.text));
                Navigator.pop(context);
                if (error != '') {
                  showDialogOfApp(context,
                      error: error,
                      onRetry: () => Future.delayed(Duration(milliseconds: 500))
                          .then((_) => _tabShowDialog.onTap()));
                  return;
                }
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ItemsCheck.withDependency(
                            type: TypeItemChecker.TESTGROUP,
                            titleSaveSuccess: assignTestSuccess,
                            resourceUri: context.read<NewAssignTestData>().id,
                            checker: [],
                            title: 'Chọn nhóm giao bài')));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15),
                margin: EdgeInsets.only(left: 60, right: 60),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFF1C18EF)),
                child: Text('GIAO KIỂM TRA',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 20.0)
          ],
        ),
      ),
    );
  }
}
