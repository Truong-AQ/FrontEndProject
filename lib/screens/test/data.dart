class TestData {
  String url, token = '';
  int questionCurrent = 0;
  bool process = false;
  List<String> idQuestions = [];
  TestData({this.url});
  TestData copy() {
    TestData clone = TestData(url: url);
    clone.token = token;
    clone.idQuestions = idQuestions;
    clone.process = process;
    clone.idQuestions = idQuestions;
    return clone;
  }
}

enum TypeQuestion {
  MULTIPLE,
  ORDERED
}