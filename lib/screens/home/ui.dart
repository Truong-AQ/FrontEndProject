import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/resources/colors.dart';
import 'package:project/resources/dimens.dart';
import 'package:project/resources/styles.dart';
import 'package:project/screens/info_patient/ui.dart';
import 'package:project/screens/list_patient/ui.dart';
import 'package:project/screens/login/controller.dart';
import 'package:project/screens/login/data.dart';
import 'package:project/screens/navigation_home/controller.dart';
import 'package:project/screens/navigation_home/data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  static withDependency() {
    return StateNotifierProvider<LoginController, LoginData>(
        create: (_) => LoginController(), child: Home());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: _buildDrawer(context),
        appBar: AppBar(),
        body: SafeArea(
          child: LayoutBuilder(builder: (context, constraint) {
            return SingleChildScrollView(
              child: Column(
                children: [_buildBody(context)],
              ),
            );
          }),
        ));
  }

  Widget _buildDrawer(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(children: [
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 45, top: 70),
            child: Image.asset('assets/images/dish2.png')),
        Container(
          padding: EdgeInsets.all(14),
          width: 250,
          color: Colors.grey,
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Text('PROFILE',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        ),
        GestureDetector(
          onTap: () {
            context.read<NavigationHomeController>().updateTabIndex(1);
          },
          child: Container(
            padding: EdgeInsets.all(14),
            color: Colors.grey,
            width: 250,
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Text('DANG KY TAI KHOAN BENH NHAN',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context.read<NavigationHomeData>().context,
                MaterialPageRoute(
                    builder: (_) => ListPatient.withDependency()));
          },
          child: Container(
            padding: EdgeInsets.all(14),
            width: 250,
            color: Colors.grey,
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Text('THEO DOI BENH NHAN',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          ),
        ),
        Container(
          padding: EdgeInsets.all(14),
          width: 250,
          color: Colors.grey,
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Text('LOGOUT',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        )
      ]),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      color: color11,
      padding: EdgeInsets.only(top: dimen17, bottom: dimen12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [SizedBox(width: dimen9), Text('CHU DE', style: style4)],
          ),
          SizedBox(height: dimen12),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (String key in topics.keys)
                    _buildTopic(context, key, topics[key]),
                ],
              )),
          SizedBox(height: dimen12),
          Row(
            children: [
              SizedBox(width: dimen9),
              Text('BENH NHAN', style: style4)
            ],
          ),
          SizedBox(height: dimen12),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (String key in patients.keys)
                    _buildPatient(context, key, patients[key]),
                ],
              )),
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
          margin: EdgeInsets.all(16),
          child: Column(children: [
            Container(
                width: 250,
                height: 250,
                child: Image.asset(url, fit: BoxFit.fill)),
            Container(
              width: 250,
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

  Widget _buildTopic(BuildContext context, String url, String name) {
    return Container(
        margin: EdgeInsets.all(16),
        child: Column(children: [
          Container(
              width: 250,
              height: 250,
              child: Image.asset(url, fit: BoxFit.fill)),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            width: 250,
            decoration:
                BoxDecoration(color: Colors.greenAccent, border: Border.all()),
            child: Text(name,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          )
        ]));
  }

  Map<String, String> patients = {
    'assets/images/tuan.png': 'TRAN TUAN',
    'assets/images/thuyet.png': 'NGOC THUYET'
  };
  Map<String, String> topics = {
    'assets/images/kettle.png': 'TRONG NHA',
    'assets/images/kettle2.png': 'NGOAI TROI'
  };
}
