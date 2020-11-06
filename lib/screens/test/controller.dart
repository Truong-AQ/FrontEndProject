import 'dart:convert';

import 'package:project/screens/test/api.dart';
import 'package:project/screens/test/data.dart';
import 'package:state_notifier/state_notifier.dart';

class TestController extends StateNotifier<TestData> {
  TestController({String url}) : super(TestData(url: url));
  Future<void> initData() async {
    state.queryParams = await getBasicInfo(url: state.url);
    final responseInitTest = await initTest(queryParams: state.queryParams);
    final jsonResponseInitTest = jsonDecode(responseInitTest.body);
    _readIdQuestions(jsonResponseInitTest);
    final responseItem = await getItem(
        queryParams: state.queryParams,
        idItem: state.idQuestions[state.questionCurrent],
        token: state.token);
    final jsonItem = jsonDecode(responseItem.body);
    _readQuestion(jsonItem);
    state.questionCurrent += 1;
    state.init = true;
    state = state.copy();
  }

  void _readIdQuestions(Map<String, dynamic> json) {
    state.token = json['token'];
    state.questionCurrent = (json['testMap']['stats']['answered'] as int) - 1;
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

  void _readQuestion(Map<String, dynamic> jsonItem) {
    state.token = jsonItem['token'];
    final String baseUrlAssets =
        (jsonItem['baseUrl'] as String).replaceAll("\/", "/");
    Map<String, dynamic> dataQuestion = {};
    Map<String, dynamic> elements =
        jsonItem['itemData']['data']['body']['elements'];
    Map<String, dynamic> element = elements.values.first;
    //load type question
    String type = element['qtiClass'];
    switch (type) {
      case 'associateInteraction':
        state.typeQuestionCurrent = TypeQuestion.PAIRING;
        break;
      case 'orderInteraction':
        state.typeQuestionCurrent = TypeQuestion.SORT;
        break;
      case 'choiceInteraction':
        state.typeQuestionCurrent = TypeQuestion.ASSIGNING;
        break;
    }
    //load prompt
    Map<String, dynamic> prompt = element['prompt'];
    final elementsPrompt = prompt['elements'];
    if (elementsPrompt is Map<String, dynamic>) {
      dataQuestion['label'] = (prompt['body'] as String).split("  ")[0].trim();
      Map<String, dynamic> attributes =
          elementsPrompt.values.first['attributes'];
      String type = attributes['type'];
      if (type == 'application/octet-stream' || type.indexOf("image") >= 0)
        type = "image";
      else if (type.indexOf("audio") >= 0) type = "audio";
      String data = "";
      if (type == "audio")
        data = "$baseUrlAssets${attributes['data']}";
      else if (type == "image") data = "$baseUrlAssets${attributes['src']}";
      dataQuestion['suggest'] = AnswerChoice(data: data, type: type);
    } else {
      dataQuestion['label'] = (prompt['body'] as String).trim();
    }
    //load choice
    Map<String, dynamic> choices = element['choices'];
    List<AnswerChoice> answers = [];
    for (var choice in choices.values) {
      String id = choice['attributes']['identifier'];
      Map<String, dynamic> bodyChoice = choice['body'];
      final elementsBodyChoice = bodyChoice['elements'];
      if (elementsBodyChoice is Map<String, dynamic>) {
        Map<String, dynamic> attributesChoice = (elementsBodyChoice.values.first
            as Map<String, dynamic>)['attributes'];
        String type = attributesChoice['type'];
        if (type.indexOf("image") >= 0)
          type = "image";
        else if (type.indexOf("audio") >= 0) type = "audio";
        String data = "";
        if (type == "audio")
          data = "$baseUrlAssets${attributesChoice['data']}";
        else if (type == "image")
          data = "$baseUrlAssets${attributesChoice['src']}";
        answers.add(AnswerChoice(id: id, data: data, type: type));
      } else {
        answers
            .add(AnswerChoice(id: id, data: bodyChoice['body'], type: 'text'));
      }
    }
    dataQuestion['answers'] = answers;
    state.dataQuestion = dataQuestion;
  }

  Future<void> getNextItem() async {
    state.process = true;
    state = state.copy();
    final responseItem = await getItem(
        queryParams: state.queryParams,
        idItem: state.idQuestions[state.questionCurrent],
        token: state.token);
    state.questionCurrent += 1;
    final jsonItem = jsonDecode(responseItem.body);
    _readQuestion(jsonItem);
    state.process = false;
    state = state.copy();
  }

  Future<void> moveItemForNextItem(
      {Map<String, dynamic> listAnswer, double timeDuration}) async {
    state.process = true;
    state = state.copy();
    final response = await moveItem(
        typeQuestion: state.typeQuestionCurrent,
        queryParams: state.queryParams,
        listChoice: listAnswer,
        timeDuration: timeDuration,
        token: state.token,
        idItem: state.idQuestions[state.questionCurrent - 1]);
    state.token = jsonDecode(response.body)['token'];
    state.process = false;
    state = state.copy();
  }
}
