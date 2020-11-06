import 'package:project/screens/test/data.dart';
import 'package:project/util/common_data_question.dart';

class OrderSentenceData extends CommonDataQuestion {
  OrderSentenceData({Map<String, dynamic> data}) {
    commonDataQuestion = this;
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
    clone.timeStart = timeStart;
    clone.userAnswer = userAnswer;
    clone.nWordsChoose = nWordsChoose;
    return clone;
  }
}
