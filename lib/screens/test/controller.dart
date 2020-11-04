import 'dart:convert';

import 'package:project/screens/test/api/api.dart';
import 'package:project/screens/test/data.dart';
import 'package:state_notifier/state_notifier.dart';

class TestController extends StateNotifier<TestData> {
  TestController({String url}) : super(TestData(url: url));
  Future<void> initData() async {
    final response =
        await initTest(queryParams: await getBasicInfo(url: state.url));
    final jsonResponse = jsonDecode(response.body);
    readIdQuestions(jsonResponse);
  }

  void readIdQuestions(Map<String, dynamic> json) {
    state.token = json['token'];
    Map<String, dynamic> jsonPart = json['testMap']['parts'];
    for (var part in jsonPart.values) {
      Map<String, dynamic> sections = part['sections'];
      for (var section in sections.values) {
        Map<String, dynamic> items = section['items'];
        for (var item in items.values) {
          state.idQuestions.add(item['id']);
        }
      }
    }
  }
}
