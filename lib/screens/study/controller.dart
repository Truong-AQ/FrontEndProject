import 'package:project/screens/study/api.dart' as api;
import 'package:project/util/function/convert_response.dart';
import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class StudyController extends StateNotifier<StudyData> {
  StudyController({StudyItem item}) : super(StudyData(item: item));
  Future<void> initStudy() async {
    StudyData st = state;
    _startProcess(st);
    await _getStudy(st);
    _doneProcess(st);
  }

  Future<void> _getStudy(StudyData st) async {
    if (st.item.items.length != 0) {
      return;
    }
    final json = await api.getStudy(classUri: st.item.dataUri);
    if (!checkResponseError(json, st)) {
      st.item.items = [];
      return;
    }
    var tree = json['tree'];
    List<dynamic> children;
    if (tree is List) {
      children = tree;
    } else {
      children = tree['children'];
    }
    for (var child in children) {
      st.item.items.add(StudyItem(
          type: child['type'],
          label: child['data'],
          dataUri: child['attributes']['data-uri']));
    }
    if (st.item.items.length > 0 && st.item.items[0].type != 'class') {
      st.item.childIsClass = false;
    }
  }

  void _startProcess(StudyData st) {
    st.error = '';
    st.process = true;
    if (mounted) state = st.copy();
  }

  void _doneProcess(StudyData st) {
    st.process = false;
    if (mounted) state = st.copy();
  }

  void refreshStudy() async {
    StudyData st = state;
    st.item.items = [];
    initStudy();
  }
}
