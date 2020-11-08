import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  static Widget withDependency() {
    return Profile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tài khoản')),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 90),
              height: 200,
              width: 200,
              child: Image.asset('assets/images/thuyet.png'),
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 150,
                  child: Text('First name',
                      style: TextStyle(fontFamily: 'monospace', fontSize: 16)),
                ),
                Expanded(
                    child: TextFormField(
                        decoration: InputDecoration(border: InputBorder.none),
                        enabled: false,
                        initialValue: 'Do',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)))
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 150,
                  child: Text('Last name',
                      style: TextStyle(fontFamily: 'monospace', fontSize: 16)),
                ),
                Expanded(
                    child: TextFormField(
                        enabled: false,
                        decoration: InputDecoration(border: InputBorder.none),
                        initialValue: 'Ngoc Thuyet',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)))
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 150,
                  child: Text('Tên đăng nhập',
                      style: TextStyle(fontFamily: 'monospace', fontSize: 16)),
                ),
                Expanded(
                    child: TextFormField(
                        decoration: InputDecoration(border: InputBorder.none),
                        initialValue: 'duan1',
                        enabled: false,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)))
              ],
            ),
          )
        ],
      )),
    );
  }
}
