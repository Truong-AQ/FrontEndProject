import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class OrderSentenceController extends StateNotifier<OrderSentenceData> {
  OrderSentenceController() : super(OrderSentenceData());

  addAnswer(int index) {
    state.answerUser[state.nWordsChoosed++] = state.questions[index];
    state.questions[index] = '';
    state.isCorrect = checkCorrect(state.answerUser, state.correctAnswer);
    state.isComplete = (state.nWordsChoosed == state.correctAnswer.length);
    state = state.copy();
  }

  removeAnswer(int index) {
    for (int i = 0; i < state.questions.length; i++) {
      if (state.questions[i] == '') {
        state.questions[i] = state.answerUser[index];
        break;
      }
    }
    state.answerUser[index] = '';
    for (int i = index; i < state.correctAnswer.length; i++) {
      state.answerUser[i] = state.answerUser[i + 1];
    }
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
