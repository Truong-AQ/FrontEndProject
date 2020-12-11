import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/resources/strings.dart';
import 'package:project/screens/patient/navigation_home/ui.dart' as patient;
import 'package:project/screens/doctor/navigation_home/ui.dart' as doctor;
import 'package:project/util/function/show_dialog_general.dart';
import 'package:project/util/variable.dart';
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
    return Scaffold(body: _buildLoginForm(context));
  }

  Widget _buildLoginForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(urlIconProfile),
          SizedBox(height: 25),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFormField(
                decoration: InputDecoration(hintText: 'Nhập tên đăng nhập'),
                onChanged: (name) {
                  context.read<RegisterPatientController>().setName(name);
                },
              )),
          SizedBox(height: 30),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFormField(
                decoration: InputDecoration(hintText: 'Nhập mật khẩu'),
                obscureText: true,
                onChanged: (password) {
                  context
                      .read<RegisterPatientController>()
                      .setPassword(password);
                },
              )),
          SizedBox(height: 40),
          _tabShowDialog = GestureDetector(
            onTap: () async {
              showDialog(context: context, builder: (_) => Loading());
              var error =
                  await context.read<RegisterPatientController>().login();
              if (error == '') {
                error =
                    await context.read<RegisterPatientController>().getRole();
                Navigator.pop(context);
                if (error == '') {
                  final role = context.read<RegisterPatientData>().role;
                  if (role == 'doctor') {
                    Navigator.pushReplacement(
                        contextLogin,
                        MaterialPageRoute(
                            builder: (_) =>
                                doctor.NavigationHome.withDependency()));
                    contextLogin = null;
                  } else {
                    Navigator.pushReplacement(
                        contextLogin,
                        MaterialPageRoute(
                            builder: (_) =>
                                patient.NavigationHome.withDependency()));
                    contextLogin = null;
                  }
                  return;
                }
              } else {
                Navigator.pop(context);
              }

              showDialogOfApp(context,
                  error: error,
                  onRetry: () => Future.delayed(Duration(milliseconds: 500))
                      .then((_) => _tabShowDialog.onTap()));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 15),
              margin: EdgeInsets.only(left: 60, right: 60),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xFF1C18EF)),
              child: Text('ĐĂNG NHẬP',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: 20.0)
        ],
      ),
    );
  }
}
