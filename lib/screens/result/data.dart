class ResultData {
  bool process = false;
  List<ResultTest> result = [];
  bool polling = false;
  ResultData copy() {
    final clone = ResultData();
    clone.process = process;
    clone.result = result;
    clone.polling = polling;
    return clone;
  }
}

class ResultTest {
  String type, label, dataUri;
  ResultTest({this.type, this.label, this.dataUri});
}
