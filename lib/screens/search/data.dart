import 'package:project/screens/search/api/response.dart';

class SearchData {
  bool process = false;
  Topic topic;
  SearchData copy() {
    final clone = SearchData();
    clone.process = process;
    clone.topic = topic;
    return clone;
  }
}

class Topic {
  ResponseTopic child;
  List<Topic> topics;
}
