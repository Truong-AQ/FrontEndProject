import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class OrderSentenceController extends StateNotifier<OrderSentenceData> {
  OrderSentenceController(Map<String, dynamic> data)
      : super(OrderSentenceData(data: data));

  void updateTime(DateTime time) {
    OrderSentenceData st = state;
    if (time.isAfter(st.timeStart)) {
      st.timeStart = time;
    }
  }

  void addAnswer(int index) {
    OrderSentenceData st = state;
    st.userAnswer[st.nWordsChoose] = st.answers[index];
    st.nWordsChoose += 1;
    st.answers[index] = null;
    if (mounted) state = st.copy();
  }

  void removeAnswer(int index) {
    OrderSentenceData st = state;
    for (int i = 0; i < st.answers.length; i++) {
      if (st.answers[i] == null) {
        st.answers[i] = st.userAnswer[index];
        st.userAnswer.removeAt(index);
        st.userAnswer.add(null);
        st.nWordsChoose -= 1;
        break;
      }
    }
    if (mounted) state = st.copy();
  }
}
