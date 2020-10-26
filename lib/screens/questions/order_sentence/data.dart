class OrderSentenceData {
  List<String> answers = ['LA', 'DAY', 'CAI', 'DIA'];
  List<String> correctAnswer = ['DAY', 'LA', 'CAI', 'DIA'];
  List<String> answerUser = ['', '', '', '', ''];
  bool isCorrect = false;
  bool isComplete = false;
  int nWordsChoosed = 0;
  OrderSentenceData copy() {
    final clone = OrderSentenceData();
    clone.answers = answers;
    clone.correctAnswer = correctAnswer;
    clone.answerUser = answerUser;
    clone.isCorrect = isCorrect;
    clone.nWordsChoosed = nWordsChoosed;
    clone.isComplete = isComplete;
    return clone;
  }
}
