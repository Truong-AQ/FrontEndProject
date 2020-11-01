import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/resources/colors.dart';
import 'package:project/resources/dimens.dart';
import 'package:project/widgets/expansion.dart';
import 'package:project/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:project/resources/styles.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:project/screens/search/controller.dart';
import 'package:project/screens/search/data.dart';

// ignore: must_be_immutable
class Search extends StatelessWidget {
  static withDependency() {
    return StateNotifierProvider<SearchController, SearchData>(
        create: (_) => SearchController()..initTopics(), child: Search());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(body: SafeArea(
        child: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                  child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        context.read<SearchController>().getTopics();
                      },
                      child: _buildSearch(context)),
                  Expanded(child: _buildBody(context))
                ],
              )),
            ),
          );
        }),
      )),
      Selector<SearchData, bool>(
        selector: (_, dt) => dt.process,
        builder: (_, process, __) {
          return process ? Loading() : Container();
        },
      )
    ]);
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
          Selector<SearchData, Topic>(
              selector: (_, dt) => dt.topic,
              builder: (_, topic, __) {
                if (topic != null) {
                  List<Widget> widgetTopic = [];
                  for (int i = 0; i < topic.child.tree.length; i++) {
                    widgetTopic.add(_buildResultSearch(
                        topic.child.tree[i].data,
                        context,
                        1,
                        topic,
                        i,
                        topic.child.tree[i].attributes.dataUri,
                        topic.child.tree[i].attributes.classAttribute !=
                            'node-class'));
                  }
                  return Column(children: widgetTopic);
                }
                return Container();
              })
        ],
      ),
    );
  }

  Widget _buildResultSearch(String text, BuildContext context, int order,
      Topic topic, int index, String classUri, bool isQuestion) {
    return Expansion(
        isQuestion: isQuestion,
        marginLeft: (order - 1) * 9.0,
        label: text,
        generateBody: () async {
          await context
              .read<SearchController>()
              .updateTopics(classUri: classUri);
          Topic topicThis = topic.topics[index];
          return Column(children: [
            for (int i = 0; i < topicThis.child.tree.length; i++)
              _buildResultSearch(
                  topicThis.child.tree[i].data,
                  context,
                  order + 1,
                  topic.topics[index],
                  i,
                  topicThis.child.tree[i].attributes.dataUri,
                  topicThis.child.tree[i].attributes.classAttribute !=
                      'node-class'),
          ]);
        });
  }
}
