import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/resources/colors.dart';
import 'package:project/resources/dimens.dart';
import 'package:project/resources/styles.dart';
import 'package:project/screens/info_patient/ui.dart';
import 'package:project/screens/login/controller.dart';
import 'package:project/screens/login/data.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

// ignore: must_be_immutable
class ListPatient extends StatelessWidget {
  static withDependency() {
    return StateNotifierProvider<LoginController, LoginData>(
        create: (_) => LoginController(), child: ListPatient());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
                child: Column(
              children: [
                _buildSearch(context),
                Expanded(child: _buildBody(context))
              ],
            )),
          ),
        );
      }),
    ));
  }

  Widget _buildSearch(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: dimen6, vertical: dimen5),
      height: dimen20,
      color: color10,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(dimen3),
          color: color4,
        ),
        child: Row(
          children: [
            SizedBox(width: dimen21),
            Icon(Icons.search, color: color2),
            SizedBox(width: dimen21),
            Expanded(
                child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: dimen22)))),
            SizedBox(width: dimen21)
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      color: color11,
      padding: EdgeInsets.only(
          top: dimen17, left: dimen9, right: dimen9, bottom: dimen12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('BENH NHAN', style: style4),
          SizedBox(height: dimen12),
          for (String key in patients.keys)
            _buildPatient(context, key, patients[key]),
        ],
      ),
    );
  }

  Widget _buildPatient(BuildContext context, String url, String name) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => InfoPatient.withDependency()));
      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Column(children: [
            Container(
                width: double.infinity,
                child: Image.asset(url, fit: BoxFit.fill)),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.greenAccent, border: Border.all()),
              child: Text(name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'monospace')),
            )
          ])),
    );
  }

  Map<String, String> patients = {
    'assets/images/dish.png': 'TRAN TUAN',
    'assets/images/bowl.png': 'NGOC THUYET'
  };
}