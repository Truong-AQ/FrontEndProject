class TestData {
  String url, token = '';
  int questionCurrent = 0;
  bool process = false, init = false;
  TypeQuestion typeQuestionCurrent;
  List<String> idQuestions = [];
  Map<String, dynamic> queryParams, dataQuestion;
  TestData({this.url});
  TestData copy() {
    TestData clone = TestData(url: url);
    clone.token = token;
    clone.idQuestions = idQuestions;
    clone.process = process;
    clone.idQuestions = idQuestions;
    clone.queryParams = queryParams;
    clone.dataQuestion = dataQuestion;
    clone.questionCurrent = questionCurrent;
    clone.typeQuestionCurrent = typeQuestionCurrent;
    clone.init = init;
    return clone;
  }
}

enum TypeQuestion { ASSIGNING, SORT, PAIRING }

class AnswerChoice {
  String data, type, id;
  AnswerChoice({this.type, this.data, this.id});
}
