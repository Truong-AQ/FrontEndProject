import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/resources/app_context.dart';
import 'package:project/resources/colors.dart';
import 'package:project/resources/dimens.dart';
import 'package:project/resources/styles.dart';
import 'package:project/screens/navigation_home/ui.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:project/screens/login/controller.dart';
import 'package:project/screens/login/data.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

class Login extends StatelessWidget {
  static withDependency() {
    return StateNotifierProvider<LoginController, LoginData>(
        create: (context) {
          contextLogin = context;
          return LoginController();
        },
        child: Login());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color10,
        appBar: AppBar(backgroundColor: color3, elevation: 0),
        body: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                  child: Column(
                children: [
                  _buildTextLogin(context),
                  _buildLoginForm(context),
                ],
              )),
            ),
          );
        }));
  }

  Widget _buildTextLogin(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 80, bottom: dimen4),
      alignment: Alignment.center,
      child: Text('Đăng nhập',
          style: TextStyle(
              color: color2, fontWeight: FontWeight.bold, fontSize: dimen2)),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: color4,borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight: Radius.circular(24))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: dimen2),
            Container(
              margin: style1,
              child: Text('Tên Đăng Nhập:', style: style3),
            ),
            SizedBox(height: dimen5),
            Container(
                margin: style1,
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'Nhập tên đăng nhập'),
                  onChanged: (name) {
                    context.read<LoginController>().setName(name);
                  },
                )),
            SizedBox(height: dimen4),
            Container(
              margin: style1,
              child: Text('Mật khẩu:', style: style3),
            ),
            SizedBox(height: dimen5),
            Container(
                margin: style1,
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'Nhập Mật khẩu'),
                  obscureText: true,

                  onChanged: (password) {
                    context.read<LoginController>().setPassword(password);
                  },
                )),
            SizedBox(height: dimen2),
            GestureDetector(
              onTap: () async {
                showDialog(context: context, builder: (_) => Loading());
                final error = await context.read<LoginController>().login();
                Navigator.pop(context);
                if (error == '') {
                  Navigator.pushReplacement(
                      contextLogin,
                      MaterialPageRoute(
                          builder: (_) => NavigationHome.withDependency()));
                  return;
                }
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return CupertinoAlertDialog(
                        title: Text(error,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: dimen9,
                                color: color7,
                                fontFamily: 'roboto')),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'))
                        ],
                      );
                    });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: dimen5),
                margin: EdgeInsets.only(left: 60, right: 60),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: color5, borderRadius: BorderRadius.circular(20)),
                child: Text('ĐĂNG NHẬP',
                    style: TextStyle(
                        color: color4,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ),
            ),
            SizedBox(height: dimen4)
          ],
        ),
      ),
    );
  }
}
