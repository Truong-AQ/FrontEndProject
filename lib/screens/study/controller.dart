import 'dart:convert';

import 'package:project/screens/study/api.dart' as api;
import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class StudyController extends StateNotifier<StudyData> {
  StudyController({String classUri}) : super(StudyData(classUri: classUri));
  Future<void> initStudy() async {
    state.process = true;
    state = state.copy();
    await getStudy(classUri: state.classUri);
    state.process = false;
    state = state.copy();
  }

  Future<void> getStudy({String classUri}) async {
    Map<String, dynamic> json =
        jsonDecode((await api.getStudy(classUri: classUri)).body);
    var tree = json['tree'];
    List<dynamic> children;
    if (tree is List) {
      children = tree;
    } else {
      children = tree['children'];
    }
    for (var child in children) {
      state.items.add(StudyItem(
          type: child['type'],
          label: child['data'],
          dataUri: child['attributes']['data-uri']));
    }
    if (state.items.length > 0 && state.items[0].type != 'class') {
      state.childIsClass = true;
    }
  }
}
