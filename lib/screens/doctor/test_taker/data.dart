import 'package:project/resources/types.dart';

class TestTakerData extends InfoError {
  bool init = false;
  List<TesttakerItem> items = [];
  TestTakerData copy() {
    TestTakerData clone = TestTakerData();
    clone.init = init;
    clone.items = items;
    clone.setValue(error: error, numOfError: numOfError);
    return clone;
  }
}

class TesttakerItem {
  TesttakerItem({this.data, this.type, this.id, this.dataUri});
  String data, type, id, dataUri;
  List<TesttakerItem> items = [];
  Map<String, List> checker;
}
