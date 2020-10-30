import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/resources/colors.dart';
import 'package:project/resources/dimens.dart';
import 'package:project/resources/styles.dart';
import 'package:project/screens/navigation_home/controller.dart';
import 'package:project/screens/navigation_home/data.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:project/screens/login/controller.dart';
import 'package:project/screens/login/data.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

class Register extends StatelessWidget {
  static withDependency() {
    return StateNotifierProvider<LoginController, LoginData>(
        create: (_) => LoginController(), child: Register());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color1,
        appBar: AppBar(
            backgroundColor: color3,
            leading: GestureDetector(
                onTap: () {
                  try {
                    context.read<NavigationHomeController>().updateTabIndex(0);
                  } on Exception catch (_) {
                    Navigator.pop(context);
                  }
                },
                child: Icon(Icons.arrow_back_sharp, color: color2)),
            elevation: 0),
        body: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                  child: Column(
                children: [
                  _buildTextRegister(context),
                  _buildRegisterForm(context),
                ],
              )),
            ),
          );
        }));
  }

  Widget _buildTextRegister(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: dimen12, bottom: dimen4),
      alignment: Alignment.center,
      child: Text('Dang ky',
          style: TextStyle(
              color: color2,
              fontWeight: FontWeight.bold,
              fontSize: dimen2,
              fontStyle: FontStyle.italic)),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Expanded(
      child: Container(
        // height: MediaQuery.of(context).size.height * dimen10,
        decoration: BoxDecoration(
            color: color4,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(dimen4),
                topRight: Radius.circular(dimen4))),
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
            SizedBox(height: dimen4),
            Container(
              margin: style1,
              child: Text('NHAP LAI MAT KHAU', style: style3),
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
            SizedBox(height: dimen4),
            Container(
              margin: style1,
              child: Text('EMAIL', style: style3),
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
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return AlertDialog(
                        title: error != ''
                            ? Text(error,
                                style:
                                    TextStyle(fontSize: dimen9, color: color7))
                            : Text('Dang nhap thanh cong',
                                style: TextStyle(fontSize: dimen9)),
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
              child: GestureDetector(
                onTap: () {
                  try {
                    context.read<NavigationHomeData>();
                  } on Exception catch (_) {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: dimen5),
                  margin: style1,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: color5,
                      borderRadius: BorderRadius.circular(dimen3)),
                  child: Text('DANG KY',
                      style: TextStyle(
                          color: color4,
                          fontWeight: FontWeight.bold,
                          fontSize: dimen8)),
                ),
              ),
            ),
            SizedBox(height: dimen4)
          ],
        ),
      ),
    );
  }
}
