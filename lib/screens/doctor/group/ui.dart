import 'package:flutter/material.dart';

import '../../../widgets/icon_refresh.dart';

class Group extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nhóm'), centerTitle: true, actions: [
        IconRefresh(),
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Container(
                          width: 350,
                          margin: EdgeInsets.only(top: 70),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              SizedBox(height: 15),
                              Material(
                                  child: TextFormField(
                                decoration:
                                    InputDecoration(hintText: 'Nhập tên nhóm'),
                              )),
                              SizedBox(height: 10),
                              Container(
                                  width: 320,
                                  decoration: BoxDecoration(
                                      color: Colors.blue.withAlpha(50)),
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  child: Text('Tạo',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 14,
                                          color: Colors.black,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.normal))),
                              SizedBox(height: 15)
                            ],
                          ),
                        )
                      ],
                    );
                  });
            })
      ]),
      body: Column(
        children: [
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 70),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              SizedBox(height: 15),
                              Container(
                                  width: 320,
                                  decoration: BoxDecoration(
                                      color: Colors.blue.withAlpha(50)),
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  child: Text('Chọn người làm bài cho nhóm',
                                      style: TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 14,
                                          color: Colors.black,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.normal))),
                              Container(
                                  width: 320,
                                  decoration: BoxDecoration(
                                      color: Colors.blue.withAlpha(50)),
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  child: Text('Giao bài cho nhóm',
                                      style: TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 14,
                                          color: Colors.black,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.normal))),
                              SizedBox(height: 15)
                            ],
                          ),
                        )
                      ],
                    );
                  });
            },
            child: Container(
              decoration: BoxDecoration(color: Colors.blue.withAlpha(30)),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: Row(children: [
                Text('Group 1', style: TextStyle(fontFamily: 'monospace')),
              ]),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.blue.withAlpha(30)),
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: Row(children: [
              Text('Group 2', style: TextStyle(fontFamily: 'monospace')),
            ]),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.blue.withAlpha(30)),
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: Row(children: [
              Text('tkgdnd', style: TextStyle(fontFamily: 'monospace')),
            ]),
          )
        ],
      ),
    );
  }
}
