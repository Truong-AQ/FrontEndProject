import 'package:project/resources/types.dart';

class TestData extends InfoError {
  bool init = false;
  List<TestItem> items = [];
  TestData copy() {
    TestData clone = TestData();
    clone.init = init;
    clone.items = items;
    clone.setValue(error: error, numOfError: numOfError);
    return clone;
  }
}

class TestItem {
  TestItem({this.data, this.type, this.id, this.dataUri});
  String data, type, id, dataUri;
  List<TestItem> items = [];
  Map<String, List> checker;
}
