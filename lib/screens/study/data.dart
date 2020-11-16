class StudyData {
  StudyData({this.classUri});
  bool process = false, childIsClass = true;
  String classUri;
  List<StudyItem> items = [];
  StudyData copy() {
    final clone = StudyData(classUri: classUri);
    clone.process = process;
    clone.items = items;
    clone.childIsClass = childIsClass;
    return clone;
  }
}

class StudyItem {
  String type, label, dataUri;
  StudyItem({this.type, this.label, this.dataUri});
}
