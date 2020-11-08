import 'dart:async';

import 'package:html/parser.dart';
import 'package:project/screens/exercise/api.dart';
import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class ExerciseController extends StateNotifier<ExerciseData> {
  ExerciseController() : super(ExerciseData());

  Future<void> initTests() async {
    state.process = true;
    state = state.copy();
    while (true) {
      try {
        await _polling();
        break;
      } on Exception catch (_) {
        await Future.delayed(Duration(seconds: 5));
      }
    }
    state.process = false;
    state = state.copy();
  }

  void startPolling() {
    if (state.timer == null || !state.timer.isActive) {
      state.timer = Timer.periodic(Duration(seconds: 5), (timer) async {
        try {
          await _polling();
          if (mounted) {
            state = state.copy();
          }
        } on Exception catch (_) {}
      });
    }
  }

  void stopPolling() {
    state.timer.cancel();
  }

  Future<void> _polling() async {
    String htmlTests = (await getTests()).body;
    final document = parse(htmlTests);
    var entries = document.getElementsByClassName('entry-point-box plain');
    List<Exercise> test = [];
    //load test have
    if (entries.length > 0) {
      var childrenHave = entries[entries.length - 1].getElementsByClassName(
          'block entry-point entry-point-all-deliveries');

      for (int i = 0; i < childrenHave.length; i++) {
        test.add(Exercise(
            link: childrenHave[i].attributes['data-launch_url'],
            label: childrenHave[i].getElementsByTagName('h3')[0].text));
      }
    }
    //load test in process
    if (entries.length == 2) {
      var childrenProcess = entries[0].getElementsByClassName(
          'block entry-point entry-point-started-deliveries');
      for (int i = 0; i < childrenProcess.length; i++) {
        test.add(Exercise(
            isProcess: true,
            link: childrenProcess[i].attributes['data-launch_url'],
            label: childrenProcess[i].getElementsByTagName('h3')[0].text,
            time: childrenProcess[i].getElementsByTagName('p')[0].text));
      }
    }
    //remove duplicate
    for (int i = test.length - 1; i >= 1; i--) {
      for (int j = i - 1; j >= 0; j--) {
        if (test[j].label == test[i].label) {
          test.removeAt(j);
          i--;
        }
      }
    }
    if (mounted) {
      state.test = test;
    }
  }
}
