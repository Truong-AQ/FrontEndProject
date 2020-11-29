import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class PairingController extends StateNotifier<PairingData> {
  PairingController(Map<String, dynamic> data) : super(PairingData(data: data));

  void updateTime(DateTime time) {
    PairingData st = state;
    if (time.isAfter(st.timeStart)) {
      st.timeStart = time;
    }
  }

  void addAnswer(int index) {
    PairingData st = state;
    for (int i = 0; i < st.userAnswer.length; i++) {
      if (st.userAnswer[i] == null) {
        st.userAnswer[i] = st.answers[index];
        st.answers[index] = null;
        break;
      }
    }
    if (mounted) state = st.copy();
  }

  void removeAnswer(int index) {
    PairingData st = state;
    if (st.haveImg && st.userAnswer[index].type != 'image') {
      return;
    }
    for (int i = 0; i < st.answers.length; i++) {
      if (st.answers[i] == null) {
        st.answers[i] = st.userAnswer[index];
        st.userAnswer[index] = null;
        break;
      }
    }
    if (mounted) state = st.copy();
  }
}
