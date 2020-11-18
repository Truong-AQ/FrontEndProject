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
          Image.asset('assets/images/ic_profile.png'),
          SizedBox(height: 25),
          Container(
              margin: style1,
              child: TextFormField(
                decoration: InputDecoration(hintText: 'Nhập tên đăng nhập'),
                onChanged: (name) {
                  context.read<LoginController>().setName(name);
                },
              )),
          SizedBox(height: 30),
          Container(
              margin: style1,
              child: TextFormField(
                decoration: InputDecoration(hintText: 'Nhập mật khẩu'),
                obscureText: true,
                onChanged: (password) {
                  context.read<LoginController>().setPassword(password);
                },
              )),
          SizedBox(height: 40),
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
                contextLogin = null;
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
              padding: EdgeInsets.symmetric(vertical: 15),
              margin: EdgeInsets.only(left: 60, right: 60),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: color5),
              child: Text('ĐĂNG NHẬP',
                  style: TextStyle(
                      color: color4,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: dimen4)
        ],
      ),
    );
  }
}
