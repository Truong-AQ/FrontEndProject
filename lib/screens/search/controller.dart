import 'dart:convert';

import 'package:project/screens/search/api/api.dart' as api;
import 'package:project/screens/search/api/response.dart';
import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class SearchController extends StateNotifier<SearchData> {
  SearchController() : super(SearchData());
  Future<void> getTopics({String classUri}) async {
    print('start get topic');
    state.process = true;
    state = state.copy();
    state.topic = await _getTopics(classUri: classUri);
    state.process = false;
    state = state.copy();
    print('done get topic');
  }

  Future<Topic> _getTopics({String classUri}) async {
    final response = await api.getTopics(classUri: classUri);
    Topic topic = Topic();
    topic.child = ResponseTopic.fromJson(jsonDecode(response.body));
    for (int i = 0; i < topic.child.tree.length; i++) {
      print(topic.child.tree[i].data);
      topic.topics.add(
          await _getTopics(classUri: topic.child.tree[i].attributes.dataUri));
    }
    return topic;
  }
}
