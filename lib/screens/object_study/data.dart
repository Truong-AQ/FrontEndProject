class ObjectStudyData {
  ObjectStudyData({this.listUri});
  bool process = false;
  List<String> listUri;
  List<ObjectStudyItem> items = [];
  ObjectStudyData copy() {
    final clone = ObjectStudyData(listUri: listUri);
    clone.process = process;
    clone.items = items;
    return clone;
  }
}

class ObjectStudyItem {
  String type, label, dataUri;
  ObjectStudyItem({this.type, this.label, this.dataUri});
}
