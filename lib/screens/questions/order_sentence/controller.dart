import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class OrderSentenceController extends StateNotifier<OrderSentenceData> {
  OrderSentenceController(Map<String, dynamic> data)
      : super(OrderSentenceData(data: data));

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
    for (int i = 0; i < state.answers.length; i++) {
      if (state.answers[i] == null) {
        state.answers[i] = state.userAnswer[index];
        state.userAnswer.removeAt(index);
        state.userAnswer.add(null);
        state.nWordsChoose -= 1;
        break;
      }
    }
    state = state.copy();
  }
}
