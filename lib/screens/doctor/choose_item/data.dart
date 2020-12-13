import 'package:project/resources/types.dart';

class ChooseItemData extends InfoError {
  ChooseItemData({this.uri});
  String uri;
  bool init = false;
  List<ChooseItem> items = [];
  List<ChooseItem> checker = [];
  ChooseItemData copy() {
    ChooseItemData clone = ChooseItemData();
    clone.init = init;
    clone.items = items;
    clone.uri = uri;
    clone.setValue(error: error, numOfError: numOfError);
    return clone;
  }
}

class ChooseItem {
  ChooseItem({this.data, this.type, this.uri, this.isCheck = false});
  String data, type, uri;
  bool isCheck;
  List<ChooseItem> items = [];
  Map<String, List> checker;
}
