import 'dart:async';

class ExerciseData {
  List<Exercise> test = [];
  bool process = false, polling = false;
  String name;

  ExerciseData copy() {
    ExerciseData exercise = ExerciseData();
    exercise.test = test;
    exercise.process = process;
    exercise.name = name;
    exercise.polling = polling;
    return exercise;
  }
}

class Exercise {
  String link, label, time;
  bool isProcess;
  String numAttempts;
  Exercise({this.numAttempts, this.link, this.label, this.time, this.isProcess = false});
}
