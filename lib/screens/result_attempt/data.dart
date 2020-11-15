class ResultTestTimeData {
  ResultTestTimeData({this.dataUri});
  bool init = false;
  String dataUri;
  ResultTestTimeData copy() {
    final clone = ResultTestTimeData();
    clone.dataUri = dataUri;
    clone.init = init;
    return clone;
  }
}
