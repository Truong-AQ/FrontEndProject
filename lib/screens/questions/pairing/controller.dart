import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class PairingController extends StateNotifier<PairingData> {
  PairingController() : super(PairingData());

  addAnswer(int index) {
    for (int i = 0; i < state.answerUser.length; i++) {
      if (state.answerUser[i] == '') {
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
    if (state.answerUser[index] == '') return;
    for (int i = 0; i < state.questions.length; i++) {
      if (state.questions[i] == '') {
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
    for (int i = 0; i < correctAnswer.length; i += 2) {
      int pos1 = answerUser.indexOf(correctAnswer[i]);
      int pos2 = answerUser.indexOf(correctAnswer[i + 1]);
      if (pos1 == -1 || pos2 == -1 || (pos1 - pos2 != 1 && pos1 - pos2 != -1)) {
        return false;
      }
    }
    return true;
  }
}
