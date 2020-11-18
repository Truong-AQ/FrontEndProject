import 'dart:convert';

import 'package:project/screens/study/api.dart' as api;
import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class StudyController extends StateNotifier<StudyData> {
  StudyController({StudyItem item}) : super(StudyData(item: item));
  Future<void> initStudy() async {
    state.process = true;
    state = state.copy();
    await getStudy();
    state.process = false;
    state = state.copy();
  }

  Future<void> getStudy() async {
    if (state.item.items == null) {
      state.item.items = [];
    } else
      return;
    Map<String, dynamic> json =
        jsonDecode((await api.getStudy(classUri: state.item.dataUri)).body);
    var tree = json['tree'];
    List<dynamic> children;
    if (tree is List) {
      children = tree;
    } else {
      children = tree['children'];
    }
    for (var child in children) {
      state.item.items.add(StudyItem(
          type: child['type'],
          label: child['data'],
          dataUri: child['attributes']['data-uri']));
    }
    if (state.item.items.length > 0 && state.item.items[0].type != 'class') {
      state.item.childIsClass = false;
    }
  }

  void changeProcess(bool process) {
    state.process = process;
    state = state.copy();
  }
}
