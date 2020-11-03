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
        backgroundColor: color1,
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
      margin: EdgeInsets.only(top: dimen1, bottom: dimen4),
      alignment: Alignment.center,
      child: Text('Dang nhap',
          style: TextStyle(
              color: color2, fontWeight: FontWeight.bold, fontSize: dimen2)),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: color4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: dimen2),
            Container(
              margin: style1,
              child: Text('TEN DANG NHAP', style: style3),
            ),
            SizedBox(height: dimen5),
            Container(
                margin: style1,
                child: TextFormField(
                  decoration: style2,
                  onChanged: (name) {
                    context.read<LoginController>().setName(name);
                  },
                )),
            SizedBox(height: dimen4),
            Container(
              margin: style1,
              child: Text('MAT KHAU', style: style3),
            ),
            SizedBox(height: dimen5),
            Container(
                margin: style1,
                child: TextFormField(
                  obscureText: true,
                  decoration: style2,
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
                margin: style1,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: color5),
                child: Text('DANG NHAP',
                    style: TextStyle(
                        color: color4,
                        fontWeight: FontWeight.bold,
                        fontSize: dimen8)),
              ),
            ),
            SizedBox(height: dimen4)
          ],
        ),
      ),
    );
  }
}
