import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/resources/colors.dart';
import 'package:project/resources/dimens.dart';
import 'package:project/resources/styles.dart';
import 'package:project/screens/home/ui.dart';
import 'package:project/screens/navigation_home/data.dart';
import 'package:provider/provider.dart';
import 'package:project/screens/questions/complete_sentence/ui.dart';
import 'package:project/screens/questions/order_sentence/ui.dart';
import 'package:project/screens/questions/pairing/ui.dart';
import 'package:project/screens/questions/single_choice/ui.dart';

// ignore: must_be_immutable
class TypesQuestion extends StatelessWidget {
  static Widget withDependency(Type fromWidget) {
    return TypesQuestion(fromWidget: fromWidget);
  }

  TypesQuestion({this.fromWidget});
  Type fromWidget;
  BuildContext contextPush;
  @override
  Widget build(BuildContext context) {
    fromWidget == Home
        ? contextPush =
            Provider.of<NavigationHomeData>(context, listen: false).context
        : contextPush = context;
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
          Text('LOAI CAU HOI', style: style4),
          SizedBox(height: dimen12),
          for (int i = 0; i < resultSearch.length; i++)
            _buildResultSearch(resultSearch[i])
        ],
      ),
    );
  }

  Widget _buildResultSearch(String text) {
    Function onTap;
    switch (text) {
      case 'LUA CHON':
        onTap = () {
          Navigator.push(contextPush,
              MaterialPageRoute(builder: (_) => SingleChoice.withDependency()));
        };
        break;
      case 'SAP XEP CAU':
        onTap = () {
          Navigator.push(
              contextPush,
              MaterialPageRoute(
                  builder: (_) => OrderSentence.withDependency()));
        };
        break;
      case 'HOAN THANH CAU':
        onTap = () {
          Navigator.push(
              contextPush,
              MaterialPageRoute(
                  builder: (_) => CompleteSentence.withDependency()));
        };
        break;
      case 'NOI TU':
        onTap = () {
          Navigator.push(contextPush,
              MaterialPageRoute(builder: (_) => Pairing.withDependency()));
        };
        break;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: style5,
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(bottom: dimen12),
        padding: EdgeInsets.all(dimen3),
        child: Text(text, style: style4),
      ),
    );
  }

  List<String> resultSearch = [
    'LUA CHON',
    'SAP XEP CAU',
    'HOAN THANH CAU',
    'NOI TU'
  ];
}
