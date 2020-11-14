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

  void startPolling() async {
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
    state.polling = false;
  }

  Future<void> _polling() async {
    String htmlTests = (await getTests()).body;
    final document = parse(htmlTests);
    String name = document.getElementsByClassName("text")[1].text;
    var entries = document.getElementsByClassName('entry-point-box plain');
    List<Exercise> test = [];
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
    //load test have
    if (entries.length > 0) {
      var childrenHave = entries[entries.length - 1].getElementsByClassName(
          'block entry-point entry-point-all-deliveries');

      for (int i = 0; i < childrenHave.length; i++) {
        test.add(Exercise(
            link: childrenHave[i].attributes['data-launch_url'],
            label: childrenHave[i].getElementsByTagName('h3')[0].text));
        List infoExtra = childrenHave[i].getElementsByTagName('p');
        if (infoExtra.length > 0) {
          test[test.length - 1].time = infoExtra[0].text;
          if (infoExtra.length == 2)
            test[test.length - 1].numAttempts = infoExtra[1].text;
        }
      }
    }

    //remove duplicate
    for (int i = 0; i < test.length - 1; i++) {
      for (int j = i + 1; j < test.length; j++) {
        if (test[j].label == test[i].label) {
          test.removeAt(j);
          j--;
        }
      }
    }
    if (mounted) {
      state.name = name;
      state.test = test;
    }
  }
}
