import 'dart:convert';

import 'package:project/resources/strings.dart';
import 'package:project/screens/result_attempt/api.dart';
import 'package:project/util/function/convert_response.dart';
import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class ResultTestTimeController extends StateNotifier<ResultTestTimeData> {
  ResultTestTimeController(String dataUri)
      : super(ResultTestTimeData(dataUri: dataUri)) {
    init(dataUri: dataUri);
  }
  void init({String dataUri}) {
    ResultTestTimeData st = state;
    _startInit(st);
    getResultTime(classUri: dataUri ?? st.dataUri).then((body) {
      if (!checkResponseError(body, st)) {
        _doneInit(st);
        return;
      }
      List<dynamic> listData = jsonDecode(body)['data'];
      for (var dt in listData) {
        if (dt['ttaker'] == nameTestTaker)
          st.list.add(ResultByTime(time: dt['time'], id: dt['id']));
      }
      _doneInit(st);
    });
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
