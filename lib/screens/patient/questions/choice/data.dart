import 'package:project/resources/types.dart';
import 'package:project/screens/patient/test/data.dart';
import 'package:project/util/variable.dart';

class ChoiceData extends CommonDataQuestion {
  ChoiceData({Map<String, dynamic> data}) {
    commonDataQuestion = this;
    if (data != null) {
      label = data['label'];
      suggest = data['suggest'];
      answers = data['answers'];
      maxChoice = data['maxChoice'];
      if (maxChoice == 1)
        formatOther = true;
      else
        formatOther = false;
      userAnswer = [];
      timeStart = DateTime.now();
    }
  }
  String label;
  int maxChoice;
  AnswerChoice suggest;
  List<AnswerChoice> answers;
  ChoiceData copy() {
    ChoiceData clone = ChoiceData();
    clone.label = label;
    clone.suggest = suggest;
    clone.answers = answers;
    clone.setValue(timeStart: timeStart, userAnswer: userAnswer);
    clone.maxChoice = maxChoice;
    return clone;
  }
}
