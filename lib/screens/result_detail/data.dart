class ResultDetailData {
  ResultDetailData({this.id, this.classUri});
  String id, classUri;
  bool init = false;
  List<int> points = [];
  ResultDetailData copy() {
    ResultDetailData clone = ResultDetailData(id: id);
    clone.points = points;
    clone.init = init;
    return clone;
  }
}
