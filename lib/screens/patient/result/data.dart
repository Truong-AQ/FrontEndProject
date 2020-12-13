import 'package:project/resources/types.dart';

class ResultData extends InfoError {
  bool process = false;
  List<ResultTest> result = [];
  ResultData copy() {
    final clone = ResultData();
    clone.process = process;
    clone.result = result;
    clone.setValue(error: error, numOfError: numOfError);
    return clone;
  }
}

class ResultTest {
  String type, data, dataUri, id;
  List<ResultTest> items = [];
  ResultTest({this.type, this.data, this.dataUri, this.id});
}
