import 'package:project/resources/types.dart';

class GroupData extends InfoError {
  bool init = false;
  List<GroupItem> items = [];
  GroupData copy() {
    GroupData clone = GroupData();
    clone.init = init;
    clone.items = items;
    clone.setValue(error: error, numOfError: numOfError);
    return clone;
  }
}

class GroupItem {
  GroupItem({this.data, this.type, this.id, this.dataUri});
  String data, type, id, dataUri;
  Map<String, List> checker;
}
