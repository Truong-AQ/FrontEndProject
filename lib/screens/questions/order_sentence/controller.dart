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

  addAnswer(int index) {
    List<String> userAnswer = state.userAnswer['identifier'];
    userAnswer.add(state.answers[index].id);
    state.nWordsChoose += 1;
    state.answers[index].id = '';
    state = state.copy();
  }

  removeAnswer(int index) {
    List<String> userAnswer = state.userAnswer['identifier'];
    for (int i = 0; i < state.answers.length; i++) {
      if (state.answers[i].id == '') {
        state.answers[i].id = userAnswer[index];
        state.nWordsChoose -= 1;
        break;
      }
    }
    userAnswer.removeAt(index);
    state = state.copy();
  }
}
