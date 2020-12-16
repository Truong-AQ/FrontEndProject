import 'package:project/resources/types.dart';

class AssignTestData extends InfoError {
  bool init = false;
  List<AssignTestItem> items = [];
  AssignTestData copy() {
    AssignTestData clone = AssignTestData();
    clone.init = init;
    clone.items = items;
    clone.setValue(error: error, numOfError: numOfError);
    return clone;
  }
}

class AssignTestItem {
  AssignTestItem({this.data, this.type, this.id, this.dataUri});
  String data, type, id, dataUri;
  List<AssignTestItem> items = [];
  Map<String, List> checker;
}
