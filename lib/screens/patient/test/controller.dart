import 'dart:convert';

import 'package:project/resources/types.dart';
import 'package:project/screens/patient/test/api.dart';
import 'package:project/screens/patient/test/data.dart';
import 'package:project/util/function/convert_response.dart';
import 'package:state_notifier/state_notifier.dart';

class TestController extends StateNotifier<TestData> {
  TestController({String url}) : super(TestData(url: url));
  Future<void> initData() async {
    TestData st = state;
    _startInit(st);
    // call 3 http request tuan tu de khoi tao bai test
    if (!await _getBasicInfo(st)) {
      _doneInit(st);
      return;
    }
    if (!await _initTest(st)) {
      _doneInit(st);
      return;
    }
    await _getItem(st);
    _doneInit(st);
  }

  Future<bool> _getBasicInfo(TestData st) async {
    if (st.stepInit != 0) return true;
    final queryParams = await getBasicInfo(url: st.url);
    if (!checkResponseError(queryParams, st)) return false;
    st.queryParams = queryParams;
    st.stepInit += 1;
    return true;
  }

  Future<bool> _initTest(TestData st) async {
    if (st.stepInit != 1) return true;
    final body = await initTest(queryParams: st.queryParams);
    if (!checkResponseError(body, st)) return false;
    final json = jsonDecode(body);
    _readIdQuestions(st, json);
    st.stepInit += 1;
    return true;
  }

  Future<void> _getItem(TestData st) async {
    final json = await getItem(
        queryParams: st.queryParams,
        idItem: st.idQuestions[st.questionCurrent],
        token: st.token);
    if (!checkResponseError(json, st)) {
      _doneProcess(st);
      return;
    }
    _readQuestion(st, json);
    st.questionCurrent += 1;
    st.stepInit += 1;
    st.action = WaitQuestion();
  }

  Future<void> getNextItem() async {
    TestData st = state;
    _startProcess(st);
    final json = await getItem(
        queryParams: st.queryParams,
        idItem: st.idQuestions[st.questionCurrent],
        token: st.token);
    if (!checkResponseError(json, st)) {
      _doneProcess(st);
      return;
    }
    _readQuestion(st, json);
    st.questionCurrent += 1;
    st.action = WaitQuestion();
    _doneProcess(st);
  }

  Future<bool> moveItemForNextItem(
      {Map<String, dynamic> listAnswer, double timeDuration}) async {
    TestData st = state;
    _startProcess(st);
    final json = await moveItem(
        typeQuestion: st.typeQuestionCurrent,
        queryParams: st.queryParams,
        listChoice: listAnswer,
        timeDuration: timeDuration,
        token: st.token,
        idItem: st.idQuestions[st.questionCurrent - 1]);
    if (!checkResponseError(json, st)) {
      _doneProcess(st);
      return false;
    }
    st.token = json['token'];
    _doneProcess(st);
    return true;
  }

  void _readIdQuestions(TestData st, Map<String, dynamic> json) {
    st.token = json['token'];
    st.questionCurrent = (json['testMap']['stats']['answered'] as int) - 1;
    Map<String, dynamic> jsonPart = json['testMap']['parts'];
    for (var part in jsonPart.values) {
      Map<String, dynamic> sections = part['sections'];
      for (var section in sections.values) {
        Map<String, dynamic> items = section['items'];
        for (var item in items.values) {
          st.idQuestions.add(item['id']);
        }
      }
    }
  }

  void _readQuestion(TestData st, Map<String, dynamic> jsonItem) {
    st.token = jsonItem['token'];
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
        st.typeQuestionCurrent = TypeQuestion.PAIRING;
        break;
      case 'orderInteraction':
        st.typeQuestionCurrent = TypeQuestion.SORT;
        break;
      case 'choiceInteraction':
        st.typeQuestionCurrent = TypeQuestion.ASSIGNING;
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
        if (type == null || type.indexOf("image") >= 0)
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
    if (st.typeQuestionCurrent == TypeQuestion.ASSIGNING) {
      dataQuestion['maxChoice'] = element['attributes']['maxChoices'];
    }
    dataQuestion['answers'] = answers;
    st.dataQuestion = dataQuestion;
  }

  void updateUserAction(UserAction action) {
    TestData st = state;
    st.action = action;
  }

  void _startInit(TestData st) {
    st.error = '';
    st.init = false;
    if (mounted) state = st.copy();
  }

  void _doneInit(TestData st) {
    st.init = true;
    if (mounted) state = st.copy();
  }

  void _startProcess(TestData st) {
    st.error = '';
    st.process = true;
    if (mounted) state = st.copy();
  }

  void _doneProcess(TestData st) {
    st.process = false;
    if (mounted) state = st.copy();
  }
}
