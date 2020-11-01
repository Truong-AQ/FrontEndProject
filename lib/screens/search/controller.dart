import 'dart:convert';

import 'package:project/screens/search/api/api.dart' as api;
import 'package:project/screens/search/api/response.dart';
import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class SearchController extends StateNotifier<SearchData> {
  SearchController() : super(SearchData());
  Future<void> initTopics() async {
    state.process = true;
    state = state.copy();
    state.topic = await getTopics();
    state.process = false;
    state = state.copy();
  }

  Future<Topic> getTopics({String classUri}) async {
    final response = await api.getTopics(classUri: classUri);
    Topic topic = Topic();
    topic.child = ResponseTopic.fromJson(jsonDecode(response.body));
    if (topic.child.tree != null)
      topic.topics = List.generate(topic.child.tree.length, (index) => null);
    if (topic.child.tree == null) return null;
    return topic;
  }

  Future<bool> updateTopics({Topic topic, String classUri}) async {
    if (topic == null) topic = state.topic;
    for (int i = 0; i < topic.child.tree.length; i++) {
      if (topic.child.tree[i].attributes.dataUri == classUri) {
        if (topic.topics[i] == null &&
            topic.child.tree[i].attributes.classAttribute == 'node-class') {
          state.process = true;
          state = state.copy();
          topic.topics[i] = await getTopics(classUri: classUri);
          state.process = false;
          state = state.copy();
        }
        return true;
      }
    }
    for (int i = 0; i < topic.child.tree.length; i++) {
      if ((topic.topics[i] != null)) if (await updateTopics(
          topic: topic.topics[i], classUri: classUri)) break;
    }
    return false;
  }
}
