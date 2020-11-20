import 'package:project/resources/types.dart';

class StudyData extends InfoError {
  StudyData({this.item}) {
    if (item == null) {
      item = StudyItem();
    }
  }
  bool process = false;
  StudyItem item;
  StudyData copy() {
    final clone = StudyData(item: item);
    clone.process = process;
    clone.setValue(error: error, numOfError: numOfError);
    return clone;
  }
}

class StudyItem {
  String type, label, dataUri;
  bool childIsClass;
  StudyItem({this.type, this.label, this.dataUri, this.childIsClass = true});
  List<StudyItem> items = [];
}
