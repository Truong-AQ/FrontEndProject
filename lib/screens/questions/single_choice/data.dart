class SingleChoiceData {
  String answerChoice = '', answerCorrect = 'assets/images/kettle.png';
  bool isCorrect = false;
  SingleChoiceData copy() {
    SingleChoiceData clone = SingleChoiceData();
    clone.answerChoice = answerChoice;
    clone.answerCorrect = answerCorrect;
    clone.isCorrect = isCorrect;
    return clone;
  }
}
