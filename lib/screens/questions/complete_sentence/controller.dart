import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class CompleteSentenceController extends StateNotifier<CompleteSentenceData> {
  CompleteSentenceController() : super(CompleteSentenceData());

  addAnswer(int index) {
    if (state.fixed[index]) return;
    for (int i = 0; i < state.answerUser.length; i++) {
      if (!state.fixed[i] && state.answerUser[i] == '') {
        state.answerUser[i] = state.questions[index];
        state.questions[index] = '';
        state.nWordsChoosed++;
        break;
      }
    }
    state.isCorrect = checkCorrect(state.answerUser, state.correctAnswer);
    state.isComplete = (state.nWordsChoosed == state.correctAnswer.length);
    state = state.copy();
  }

  removeAnswer(int index) {
    if (state.fixed[index]) return;
    for (int i = 0; i < state.questions.length; i++) {
      if (!state.fixed[i] && state.questions[i] == '') {
        state.questions[i] = state.answerUser[index];
        break;
      }
    }
    state.answerUser[index] = '';
    state.nWordsChoosed--;
    state.isComplete = (state.nWordsChoosed == state.correctAnswer.length);
    state = state.copy();
  }

  bool checkCorrect(List<String> answerUser, List<String> correctAnswer) {
    for (int i = 0; i < correctAnswer.length; i++) {
      if (answerUser[i] != correctAnswer[i]) {
        return false;
      }
    }
    return true;
  }
}
