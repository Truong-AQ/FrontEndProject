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
    var entrys = document.getElementsByClassName('entry-point-box plain');
    List<ExerciseProcess> testProcess = [];
    List<ExcerciseHave> testHave = [];
    //load test have
    if (entrys.length > 0) {
      var childrenHave = entrys[entrys.length - 1].getElementsByClassName(
          'block entry-point entry-point-all-deliveries');

      for (int i = 0; i < childrenHave.length; i++) {
        testHave.add(ExcerciseHave(
            link: childrenHave[i].attributes['data-launch_url'],
            label: childrenHave[i].getElementsByTagName('h3')[0].text));
      }
    }
    //load test in process
    if (entrys.length == 2) {
      var childrenProcess = entrys[0].getElementsByClassName(
          'block entry-point entry-point-started-deliveries');
      for (int i = 0; i < childrenProcess.length; i++) {
        testProcess.add(ExerciseProcess(
            link: childrenProcess[i].attributes['data-launch_url'],
            label: childrenProcess[i].getElementsByTagName('h3')[0].text,
            time: childrenProcess[i].getElementsByTagName('p')[0].text));
      }
    }
    if (mounted) {
      if (state.testProcess.length != testProcess.length)
        state.testProcess = testProcess;
      if (state.testHave.length != testHave.length) state.testHave = testHave;
    }
  }
}
