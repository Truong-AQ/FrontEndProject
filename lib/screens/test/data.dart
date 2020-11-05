class TestData {
  String url, token = '';
  int questionCurrent = 0;
  bool process = false;
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
    return clone;
  }
}

enum TypeQuestion { ASSIGNING, SORT, INSERTION }
