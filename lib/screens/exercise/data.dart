import 'package:project/util/variable.dart';

class ExerciseData {
  List<Exercise> test = [];
  bool process = false, polling = false;
  String name;

  ExerciseData copy() {
    ExerciseData exercise = ExerciseData();
    exercise.test = test;
    testDone = test;
    exercise.process = process;
    exercise.name = name;
    exercise.polling = polling;
    return exercise;
  }

  bool equalTest(List<Exercise> otherTest) {
    if (test.length != otherTest.length) return false;
    for (int i = 0; i < test.length; i++)
      if (!test[i].equal(otherTest[i])) return false;
    return true;
  }
}

class Exercise {
  String link, label, time;
  bool isProcess;
  String numAttempts;
  Exercise(
      {this.numAttempts,
      this.link,
      this.label,
      this.time,
      this.isProcess = false});
  bool equal(Exercise other) {
    return (this.link == other.link) &&
        (this.label == other.label) &&
        (this.time == other.time) &&
        (this.isProcess = other.isProcess) &&
        (this.numAttempts == other.numAttempts);
  }
}
