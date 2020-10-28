class CompleteSentenceData {
  List<String> questions = ['CAI', '', 'DAY', 'NUOC', '', 'AM'];
  List<String> correctAnswer = ['DAY', 'LA', 'CAI', 'AM', 'DUN', 'NUOC'];
  List<String> answerUser = ['', 'LA', '', '', 'DUN', ''];
  List<bool> fixed = [false, true, false, false, true, false];
  bool isCorrect = false;
  bool isComplete = false;
  int nWordsChoosed = 0;
  CompleteSentenceData() {
    fixed.forEach((element) {
      if (element) nWordsChoosed++;
    });
  }

  CompleteSentenceData copy() {
    final clone = CompleteSentenceData();
    clone.questions = questions;
    clone.correctAnswer = correctAnswer;
    clone.answerUser = answerUser;
    clone.isCorrect = isCorrect;
    clone.nWordsChoosed = nWordsChoosed;
    clone.isComplete = isComplete;
    return clone;
  }
}
