import 'package:project/screens/test/data.dart';
import 'package:project/util/common_data_question.dart';

class ChoiceData extends CommonDataQuestion {
  ChoiceData({Map<String, dynamic> data}) {
    if (data != null) {
      label = data['label'];
      suggest = data['suggest'];
      answers = data['answers'];
      userAnswer = {};
      userAnswer['identifier'] = [];
      timeStart = DateTime.now();
    }
  }
  String label;
  AnswerChoice suggest;
  List<AnswerChoice> answers;
  ChoiceData copy() {
    ChoiceData clone = ChoiceData();
    clone.label = label;
    clone.suggest = suggest;
    clone.answers = answers;
    clone.userAnswer = userAnswer;
    clone.timeStart = timeStart;
    return clone;
  }
}
