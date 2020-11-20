import 'package:project/resources/types.dart';

class ResultDetailData extends InfoError {
  ResultDetailData({this.id, this.classUri});
  String id, classUri;
  bool init = false;
  int totalPoint = 0;
  List<int> points = [];
  ResultDetailData copy() {
    ResultDetailData clone = ResultDetailData(id: id, classUri: classUri);
    clone.points = points;
    clone.init = init;
    clone.totalPoint = totalPoint;
    clone.setValue(error: error, numOfError: numOfError);
    return clone;
  }
}
