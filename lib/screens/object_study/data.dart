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
  String urlAudio, label, urlImg;
  ObjectStudyItem({this.urlAudio, this.label, this.urlImg});
}
