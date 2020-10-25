import 'package:project/resources/types.dart';
import 'package:project/screens/test/data.dart';
import 'package:project/util/variable.dart';

class PairingData extends CommonDataQuestion {
  PairingData({Map<String, dynamic> data}) {
    commonDataQuestion = this;
    formatOther = false;
    if (data != null) {
      label = data['label'];
      suggest = data['suggest'];
      answers = data['answers'];
      userAnswer = List.generate(answers.length, (index) => null);
      int j = 1;
      for (int i = 0; i < answers.length; i++) {
        if (answers[i].type == 'image') {
          userAnswer[j] = answers[i];
          j += 2;
          answers[i] = null;
        }
      }
      if (j != 1) {
        haveImg = true;
        j = 0;
        for (int i = 0; i < answers.length; i++) {
          while (answers[i] == null && i < answers.length) {
            i++;
          }
          if (i < answers.length) {
            answers[j] = answers[i];
            j += 2;
            if (j >= answers.length) break;
          }
        }
        for (int i = 1; i < answers.length; i += 2) {
          answers[i] = null;
        }
        List tmp = answers;
        answers = userAnswer;
        userAnswer = tmp;
      }
      timeStart = DateTime.now();
    }
  }
  String label;
  AnswerChoice suggest;
  List<AnswerChoice> answers;
  bool haveImg = false;
  PairingData copy() {
    final clone = PairingData();
    clone.label = label;
    clone.suggest = suggest;
    clone.answers = answers;
    clone.setValue(timeStart: timeStart, userAnswer: userAnswer);
    clone.haveImg = haveImg;
    return clone;
  }
}
