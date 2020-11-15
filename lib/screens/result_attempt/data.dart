class ResultTestTimeData {
  ResultTestTimeData({this.dataUri});
  bool init = false;
  List<ResultByTime> list = [];
  String dataUri;
  ResultTestTimeData copy() {
    final clone = ResultTestTimeData();
    clone.dataUri = dataUri;
    clone.init = init;
    clone.list = list;
    return clone;
  }
}
class ResultByTime {
  String id, time;
  ResultByTime({this.id, this.time});
}