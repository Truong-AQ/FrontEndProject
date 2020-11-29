import 'dart:convert';

import 'package:project/screens/patient/result_attempt/api.dart';
import 'package:project/util/function/convert_response.dart';
import 'package:project/util/variable.dart';
import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class ResultTestTimeController extends StateNotifier<ResultTestTimeData> {
  ResultTestTimeController(String dataUri)
      : super(ResultTestTimeData(dataUri: dataUri)) {
    init();
  }
  Future<void> init() async {
    ResultTestTimeData st = state;
    _startInit(st);
    await _getResultTesTimeByPage(st, page: 1);
    _doneInit(st);
  }

  Future<void> _getResultTesTimeByPage(ResultTestTimeData st,
      {int page}) async {
    final body = await getResultTime(classUri: st.dataUri, page: page);
    if (!checkResponseError(body, st)) {
      _doneInit(st);
      return;
    }
    final json = jsonDecode(body);
    List<dynamic> listData = json['data'];
    for (var dt in listData) {
      if (dt['ttaker'] == nameTestTaker)
        st.list.add(ResultByTime(time: dt['time'], id: dt['id']));
    }
    if (json['total'] > page) {
      await _getResultTesTimeByPage(st, page: page + 1);
    }
  }

  void _startInit(ResultTestTimeData st) {
    st.error = '';
    st.init = false;
    if (mounted) state = st.copy();
  }

  void _doneInit(ResultTestTimeData st) {
    st.init = true;
    if (mounted) state = st.copy();
  }
}
