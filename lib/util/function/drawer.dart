import 'package:flutter/material.dart';
import 'package:project/screens/doctor/register_patient/ui.dart';
import 'package:project/util/variable.dart';
import 'package:provider/provider.dart';
import 'package:project/resources/strings.dart';
import 'package:project/screens/doctor/navigation_home/data.dart' as doctor;
import 'package:project/screens/patient/navigation_home/data.dart' as patient;

import 'logout.dart';

Widget buildDrawerDoctor(BuildContext context) {
  return Container(
    color: Colors.white,
    width: MediaQuery.of(context).size.width * 0.8,
    child: Column(children: [
      Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 0, top: 70),
          child: Image.asset(urlIconProfile, scale: 128 / 150)),
      Container(
          padding: EdgeInsets.all(14),
          margin: EdgeInsets.only(top: 15),
          child: Selector<doctor.NavigationHomeData, String>(
            selector: (_, dt) => dt.name,
            builder: (_, name, __) {
              return Text(name ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'monospace'));
            },
          )),
      GestureDetector(
        onTap: () async {
          logout();
        },
        child: Container(
          padding: EdgeInsets.all(14),
          width: 250,
          color: Colors.grey,
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Text('Đăng xuất',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(
              contextHome,
              MaterialPageRoute(
                  builder: (_) => RegisterPatient.withDependency()));
        },
        child: Container(
          padding: EdgeInsets.all(14),
          width: 250,
          color: Colors.grey,
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Text('Đăng ký tài khoản bệnh nhân',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        ),
      ),
    ]),
  );
}

Widget buildDrawerPatient(BuildContext context) {
  return Container(
    color: Colors.white,
    width: MediaQuery.of(context).size.width * 0.8,
    child: Column(children: [
      Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 0, top: 70),
          child: Image.asset(urlIconProfile, scale: 128 / 150)),
      Container(
          padding: EdgeInsets.all(14),
          margin: EdgeInsets.only(top: 15),
          child: Selector<patient.NavigationHomeData, String>(
            selector: (_, dt) => dt.name,
            builder: (_, name, __) {
              return Text(name ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'monospace'));
            },
          )),
      GestureDetector(
        onTap: () async {
          logout();
        },
        child: Container(
          padding: EdgeInsets.all(14),
          width: 250,
          color: Colors.grey,
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Text('Đăng xuất',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        ),
      )
    ]),
  );
}
