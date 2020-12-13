import 'package:project/screens/patient/result/api.dart' as api;
import 'package:project/util/function/convert_response.dart';
import 'package:project/util/variable.dart';
import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class ResultController extends StateNotifier<ResultData> {
  ResultController() : super(ResultData());
  Future<void> initResult() async {
    ResultData st = state;
    _startProcess(st);
    await getResult(st.result);
    _doneProcess(st);
  }

  Future<bool> getResult(List<ResultTest> items, {String classUri}) async {
    items.clear();
    ResultData st = state;
    final json = await api.getResult(classUri: classUri);
    if (!checkResponseError(json, st)) return false;
    var children = json['tree'];
    if (children is Map) children = children['children'];
    for (var child in children) {
      items.add(ResultTest(
          type: child['type'],
          data: child['data'],
          id: child['attributes']['id'],
          dataUri: child['attributes']['data-uri']));
    }
    List<ResultTest> tmp = [];
    for (int i = 0; i < testOfUser.length; i++) {
      for (int j = 0; j < items.length; j++)
        if (testOfUser[i].label == items[j].data) {
          tmp.add(items[j]);
          break;
        }
    }
    for (int i = 0; i < items.length; i++) {
      if (items[i].type == 'class') tmp.add(items[i]);
    }
    items.clear();
    for (int i = 0; i < tmp.length; i++) {
      items.add(tmp[i]);
    }
    return true;
  }

  void _startProcess(ResultData st) {
    st.error = '';
    st.process = true;
    if (mounted) state = st.copy();
  }

  void _doneProcess(ResultData st) {
    st.process = false;
    if (mounted) state = st.copy();
  }
}
