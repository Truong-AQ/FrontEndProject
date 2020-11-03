import 'dart:async';

class ExerciseData {
  List<ExerciseProcess> testProcess = [];
  List<ExcerciseHave> testHave = [];
  bool process = false;
  Timer timer;

  ExerciseData copy() {
    ExerciseData exercise = ExerciseData();
    exercise.testProcess = testProcess;
    exercise.testHave = testHave;
    exercise.process = process;
    exercise.timer = timer;
    return exercise;
  }
}

class ExerciseProcess {
  String link, label, time;
  ExerciseProcess({this.link, this.label, this.time});
}

class ExcerciseHave {
  String link, label;
  ExcerciseHave({this.link, this.label});
}
