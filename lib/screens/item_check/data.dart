import 'package:project/resources/types.dart';

class ItemsCheckData extends InfoError {
  ItemsCheckData({this.type, this.checker, this.resourceUri});
  List checker;
  bool init = false;
  String resourceUri;
  TypeItemChecker type;
  List<CheckItem> items = [];

  ItemsCheckData copy() {
    ItemsCheckData clone =
        ItemsCheckData(type: type, checker: checker, resourceUri: resourceUri);
    clone.setValue(error: error, numOfError: numOfError);
    clone.type = type;
    clone.init = init;
    clone.items = items;
    return clone;
  }
}

class CheckItem {
  CheckItem({this.data, this.type, this.id, this.dataUri, this.isCheck});
  String data, type, id, dataUri;
  bool isCheck;
  List<CheckItem> items = [];
}
