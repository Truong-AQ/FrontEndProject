import 'dart:convert';

import 'package:project/screens/result/api.dart' as api;
import 'package:project/util/variable.dart';
import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class ResultController extends StateNotifier<ResultData> {
  ResultController() : super(ResultData());
  Future<void> initResult() async {
    state.process = true;
    state = state.copy();
    await _polling();
    state.process = false;
    state = state.copy();
  }

  Future<void> _polling() async {
    List<ResultTest> listResultTest = [], listResultTestOfUser = [];
    await getResult(listResultTest);
    //remove other test in result
    for (int i = 0; i < testDone.length; i++) {
      for (int j = 0; j < listResultTest.length; j++)
        if (testDone[i].label == listResultTest[j].label) {
          listResultTestOfUser.add(listResultTest[j]);
          break;
        }
    }
    if (listResultTestOfUser.length != state.result.length) {
      state.result = listResultTestOfUser;
      state = state.copy();
    }
  }

  Future<void> getResult(List<ResultTest> listResultTest,
      {String classUri}) async {
    Map<String, dynamic> json =
        jsonDecode((await api.getResult(classUri: classUri)).body);
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
        await getResult(listResultTest,
            classUri: child['attributes']['data-uri']);
      } else {
        listResultTest.add(ResultTest(
            type: type,
            label: child['data'],
            dataUri: child['attributes']['data-uri']));
      }
    }
  }

  void startPolling() async {
    print('start');
    if (mounted) {
      if (state.polling) return;
      state.polling = true;
      while (state.polling) {
        try {
          await _polling();
          await Future.delayed(Duration(seconds: 5));
          if (mounted) {
            state = state.copy();
          } else
            break;
        } on Exception catch (_) {}
      }
    }
  }

  void stopPolling() {
    print('stop');
    state.polling = false;
  }
}
