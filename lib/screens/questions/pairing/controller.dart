import 'package:project/screens/test/data.dart';
import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class PairingController extends StateNotifier<PairingData> {
  PairingController(Map<String, dynamic> data) : super(PairingData(data: data));

  void updateTime(DateTime time) {
    if (time.isAfter(state.timeStart)) {
      state.timeStart = time;
    }
  }

  void addAnswer(int index) {
    state.userAnswer[state.nWordsChoose] = state.answers[index];
    state.nWordsChoose += 1;
    state.answers[index] = null;
    state = state.copy();
  }

  void removeAnswer(int index) {
    List<AnswerChoice> answerWillRemove = [];
    answerWillRemove.add(state.userAnswer[index]);
    state.nWordsChoose -= 1;
    if (index % 2 == 0 && state.userAnswer[index + 1] != null) {
      answerWillRemove.add(state.userAnswer[index + 1]);
      state.nWordsChoose -= 1;
    } else if (index % 2 == 1 && state.userAnswer[index - 1] != null) {
      answerWillRemove.add(state.userAnswer[index - 1]);
      state.nWordsChoose -= 1;
    }
    if (index % 2 == 0) {
      state.userAnswer.removeAt(index);
      state.userAnswer.removeAt(index);
      state.userAnswer.add(null);
      state.userAnswer.add(null);
    } else {
      state.userAnswer.removeAt(index - 1);
      state.userAnswer.removeAt(index - 1);
      state.userAnswer.add(null);
      state.userAnswer.add(null);
    }
    for (int i = 0;
        i < state.answers.length && answerWillRemove.length > 0;
        i++) {
      if (state.answers[i] == null) {
        state.answers[i] = answerWillRemove[0];
        answerWillRemove.removeAt(0);
      }
    }
    state = state.copy();
  }
}
