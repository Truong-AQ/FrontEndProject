import 'package:project/screens/study/api.dart' as api;
import 'package:project/util/function/convert_response.dart';
import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class StudyController extends StateNotifier<StudyData> {
  StudyController() : super(StudyData());
  Future<void> initStudy() async {
    StudyData st = state;
    _startProcess(st);
    await getListStudyItem(st.item, st: st);
    _doneProcess(st);
  }

  Future<List<StudyItemData>> getListStudyItem(StudyItemData item,
      {StudyData st}) async {
    if (st == null) st = state;
    if (item.items.length == 0) {
      final json = await api.getStudy(classUri: item.dataUri);
      if (!checkResponseError(json, st)) {
        return [];
      }
      _readStudyItemDataFromJson(json, item.items);
    }
    return item.items;
  }

  _readStudyItemDataFromJson(
      Map<String, dynamic> json, List<StudyItemData> list) {
    var tree = json['tree'];
    List<dynamic> children;
    if (tree is List) {
      children = tree;
    } else {
      children = tree['children'];
    }
    children.forEach((child) => list.add(StudyItemData(
        type: child['type'],
        label: child['data'],
        dataUri: child['attributes']['data-uri'])));
  }

  void _startProcess(StudyData st) {
    st.error = '';
    st.item = StudyItemData();
    st.process = true;
    if (mounted) state = st.copy();
  }

  void _doneProcess(StudyData st) {
    st.process = false;
    if (mounted) state = st.copy();
  }
}
