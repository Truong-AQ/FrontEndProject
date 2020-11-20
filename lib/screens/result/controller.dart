import 'package:project/screens/result/api.dart' as api;
import 'package:project/util/function/convert_response.dart';
import 'package:project/util/variable.dart';
import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class ResultController extends StateNotifier<ResultData> {
  ResultController() : super(ResultData());
  Future<void> initResult() async {
    ResultData st = state;
    _startProcess(st);
    await _getData(st);
    _doneProcess(st);
  }

  Future<void> _getData(ResultData st) async {
    List<ResultTest> listResultTest = [];
    bool got = await _getResult(listResultTest, st);
    if (!got) return;
    //remove other test in result
    st.result = [];
    for (int i = 0; i < testDone.length; i++) {
      for (int j = 0; j < listResultTest.length; j++)
        if (testDone[i].label == listResultTest[j].label) {
          st.result.add(listResultTest[j]);
          break;
        }
    }
  }

  Future<bool> _getResult(List<ResultTest> listResultTest, ResultData st,
      {String classUri}) async {
    final json = await api.getResult(classUri: classUri);
    if (!checkResponseError(json, st)) return false;

    var tree = json['tree'];
    List<dynamic> children;
    if (tree is List) {
      children = tree;
    } else {
      children = tree['children'];
    }
    for (var child in children) {
      String type = child['type'];
      if (type == 'class') {
        final bool got = await _getResult(listResultTest, st,
            classUri: child['attributes']['data-uri']);
        if (!got) {
          return false;
        }
      } else {
        listResultTest.add(ResultTest(
            type: type,
            label: child['data'],
            dataUri: child['attributes']['data-uri']));
      }
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
