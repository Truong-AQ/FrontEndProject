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
    for (int i = 0; i < state.userAnswer.length; i++) {
      if (state.userAnswer[i] == null) {
        state.userAnswer[i] = state.answers[index];
        state.answers[index] = null;
        break;
      }
    }
    state = state.copy();
  }

  void removeAnswer(int index) {
    if (state.haveImg && state.userAnswer[index].type != 'image') {
      return;
    }
    for (int i = 0; i < state.answers.length; i++) {
      if (state.answers[i] == null) {
        state.answers[i] = state.userAnswer[index];
        state.userAnswer[index] = null;
        break;
      }
    }
    state = state.copy();
  }
}
