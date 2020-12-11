import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
class RegisterPatient extends StatelessWidget {
  GestureDetector _tabShowDialog;
  static withDependency() {
    return StateNotifierProvider<RegisterPatientController,
            RegisterPatientData>(
        create: (_) => RegisterPatientController(), child: RegisterPatient());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Đăng ký'), centerTitle: true),
        body: _buildRegisterForm(context));
  }

  Widget _buildRegisterForm(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        child: Column(
          children: [
            SizedBox(height: 35),
            Image.asset(urlIconProfile),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(hintText: 'Họ'),
                      onChanged: (firstName) {
                        context
                            .read<RegisterPatientController>()
                            .setFirstName(firstName);
                      },
                    ),
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    child: TextFormField(
                        decoration: InputDecoration(hintText: 'Tên'),
                        onChanged: (lastName) {
                          context
                              .read<RegisterPatientController>()
                              .setLastName(lastName);
                        }),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0),
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'Email'),
                  onChanged: (email) {
                    context.read<RegisterPatientController>().setEmail(email);
                  },
                )),
            SizedBox(height: 25),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0),
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'Tên đăng nhập'),
                  onChanged: (loginName) {
                    context
                        .read<RegisterPatientController>()
                        .setLoginName(loginName);
                  },
                )),
            SizedBox(height: 25),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0),
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'Mật khẩu'),
                  onChanged: (password) {
                    context
                        .read<RegisterPatientController>()
                        .setPassword(password);
                  },
                  obscureText: true,
                )),
            SizedBox(height: 25),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0),
                child: TextFormField(
                    onChanged: (againPassword) {
                      context
                          .read<RegisterPatientController>()
                          .setAgainPassword(againPassword);
                    },
                    obscureText: true,
                    decoration:
                        InputDecoration(hintText: 'Nhập lại mật khẩu'))),
            SizedBox(height: 40),
            _tabShowDialog = GestureDetector(
              onTap: () async {
                showDialog(context: context, builder: (_) => Loading());
                String error =
                    await context.read<RegisterPatientController>().register();
                Navigator.pop(context);
                if (error != '') {
                  showDialogOfApp(context,
                      error: error,
                      onRetry: () => Future.delayed(Duration(milliseconds: 500))
                          .then((_) => _tabShowDialog.onTap()));
                } else {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ItemsCheck.withDependency(
                              type: TypeItemChecker.GROUP,
                              titleSaveSuccess: registerSuccess,
                              resourceUri:
                                  context.read<RegisterPatientData>().uri,
                              checker: [],
                              title: 'Chọn nhóm cho bệnh nhân')));
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15),
                margin: EdgeInsets.only(left: 60, right: 60),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFF1C18EF)),
                child: Text('ĐĂNG KÝ',
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
