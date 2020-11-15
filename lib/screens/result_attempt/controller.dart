import 'dart:convert';

import 'package:project/resources/strings.dart';
import 'package:project/screens/result_attempt/api.dart';
import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class ResultTestTimeController extends StateNotifier<ResultTestTimeData> {
  ResultTestTimeController(String dataUri)
      : super(ResultTestTimeData(dataUri: dataUri)) {
    getResultTime(classUri: dataUri).then((value) {
      Map<String, dynamic> json = jsonDecode(value.body);
      List<dynamic> listData = json['data'];
      for (var dt in listData) {
        if (dt['ttaker'] == nameTestTaker)
          state.list.add(ResultByTime(time: dt['time'], id: dt['id']));
      }
      state.init = true;
      state = state.copy();
    });
  }
}
