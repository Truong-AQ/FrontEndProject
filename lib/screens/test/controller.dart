import 'dart:convert';

import 'package:project/screens/test/api.dart';
import 'package:project/screens/test/data.dart';
import 'package:state_notifier/state_notifier.dart';

class TestController extends StateNotifier<TestData> {
  TestController({String url}) : super(TestData(url: url));
  Future<void> initData() async {
    state.process = true;
    state = state.copy();
    state.queryParams = await getBasicInfo(url: state.url);
    final responseInitTest = await initTest(queryParams: state.queryParams);
    final jsonResponseInitTest = jsonDecode(responseInitTest.body);
    readIdQuestions(jsonResponseInitTest);
    final responseItem = await getItem(
        queryParams: state.queryParams,
        idItem: state.idQuestions[state.questionCurrent],
        token: state.token);
    final jsonItem = jsonDecode(responseItem.body);
    readQuestion(jsonItem);
    state.questionCurrent += 1;
    state.process = false;
    state = state.copy();
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

  void readQuestion(Map<String, dynamic> jsonItem) {
    state.token = jsonItem['token'];
    final String baseUrlAssets =
        (jsonItem['baseUrl'] as String).replaceAll("\/", "/");
    Map<String, dynamic> dataQuestion = {};
    Map<String, dynamic> elements =
        jsonItem['itemData']['data']['body']['elements'];
    for (var element in elements.values) {
      if (element['qtiClass'] == 'choiceInteraction') {
        state.typeQuestionCurrent = TypeQuestion.ASSIGNING;
        dataQuestion['label'] =
            jsonItem['itemData']['data']['attributes']['label'];
        Map<String, dynamic> assets = jsonItem['itemData']['assets'];
        if (assets['audio'] != '') {
          final String audio =
              (assets['audio'] as Map<String, dynamic>).values.toList()[0];
          dataQuestion['audio'] = '$baseUrlAssets$audio';
        }
        if (assets['img'] != '') {
          List<String> urlImage = [];
          Map<String, dynamic> assetsImg = assets['img'];
          for (var img in assetsImg.values) {
            urlImage.add("$baseUrlAssets$img");
          }
          dataQuestion['img'] = urlImage;
        }
        state.dataQuestion = dataQuestion;
        break;
      }
    }
  }
}
