import 'package:project/screens/test/data.dart';

//du lieu cau hoi tong quan - thoi gian, tra loi cua nguoi dung
class CommonDataQuestion {
  DateTime timeStart;
  List<AnswerChoice> userAnswer = [];
  setValue({DateTime timeStart, List<AnswerChoice> userAnswer}) {
    this.timeStart = timeStart;
    this.userAnswer = userAnswer;
  }
}

// ten loi, so lan loi
abstract class InfoError {
  String error = '';
  int numOfError = 0;
  setValue({String error, int numOfError}) {
    this.error = error;
    this.numOfError = numOfError;
  }
}

//mieu ta ve loi
class AppError {
  AppError({this.description});
  final String description;
}

//User Action - hanh dong cua nguoi dung voi app
abstract class UserAction {}

class UserActionNoData extends UserAction {}

class InitLoad extends UserActionNoData {}

class UserActionHasData extends UserAction {
  Map<String, dynamic> data = {};
  void addData(String k, dynamic v) {
    data[k] = v;
  }
}

class WaitQuestion extends UserActionNoData {}

class SubmitQuestion extends UserActionHasData {}

class GetNextQuestion extends UserActionNoData {}
