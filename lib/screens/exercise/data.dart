import 'dart:async';

class ExerciseData {
  List<Exercise> test = [];
  bool process = false;
  Timer timer;

  ExerciseData copy() {
    ExerciseData exercise = ExerciseData();
    exercise.test = test;
    exercise.process = process;
    exercise.timer = timer;
    return exercise;
  }
}

class Exercise {
  String link, label, time;
  bool isProcess;
  Exercise({this.link, this.label, this.time, this.isProcess = false});
}
