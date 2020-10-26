import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/resources/colors.dart';
import 'package:project/resources/dimens.dart';
import 'package:project/resources/styles.dart';
import 'package:project/screens/login/controller.dart';
import 'package:project/screens/login/data.dart';
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
        body: SafeArea(
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
        ),
        bottomNavigationBar: _buildBottomNavigationBar());
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
          Text('CHU DE', style: style4),
          SizedBox(height: dimen12),
          for (int i = 0; i < resultSearch.length; i++)
            _buildResultSearch(resultSearch[i]),
        ],
      ),
    );
  }

  Widget _buildResultSearch(String text) {
    return Container(
      decoration: style5,
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(bottom: dimen12),
      padding: EdgeInsets.all(dimen3),
      child: Text(text, style: style4),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
      BottomNavigationBarItem(
          icon: Icon(Icons.search_rounded), label: 'Search'),
    ]);
  }

  List<String> resultSearch = ['TRONG NHA', 'NGOAI TROI', 'DONG VAT'];
}
