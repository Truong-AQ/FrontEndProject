import 'package:project/resources/types.dart';
import 'package:project/screens/patient/test/data.dart';
import 'package:project/util/variable.dart';

class OrderSentenceData extends CommonDataQuestion {
  OrderSentenceData({Map<String, dynamic> data}) {
    commonDataQuestion = this;
    formatOther = false;
    if (data != null) {
      label = data['label'];
      suggest = data['suggest'];
      answers = data['answers'];
      userAnswer = List.generate(answers.length, (index) => null);
      timeStart = DateTime.now();
    }
  }
  String label;
  AnswerChoice suggest;
  List<AnswerChoice> answers;
  int nWordsChoose = 0;
  OrderSentenceData copy() {
    final clone = OrderSentenceData();
    clone.label = label;
    clone.suggest = suggest;
    clone.answers = answers;
    clone.setValue(timeStart: timeStart, userAnswer: userAnswer);
    clone.nWordsChoose = nWordsChoose;
    return clone;
  }
}
