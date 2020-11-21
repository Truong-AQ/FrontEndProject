import 'package:project/resources/types.dart';

class StudyData extends InfoError {
  bool process = false;
  StudyItemData item;
  StudyData copy() {
    final clone = StudyData();
    clone.process = process;
    clone.item = item;
    clone.setValue(error: error, numOfError: numOfError);
    return clone;
  }
}

class StudyItemData {
  String type, label, dataUri;
  StudyItemData({this.type, this.label, this.dataUri});
  List<StudyItemData> items = [];
}
