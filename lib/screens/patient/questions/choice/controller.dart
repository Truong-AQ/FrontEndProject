import 'package:project/screens/patient/questions/choice/data.dart';
import 'package:project/screens/patient/test/data.dart';
import 'package:state_notifier/state_notifier.dart';

class ChoiceController extends StateNotifier<ChoiceData> {
  ChoiceController(Map<String, dynamic> data) : super(ChoiceData(data: data));

  bool addAnswer(AnswerChoice answer) {
    ChoiceData st = state;
    if (st.userAnswer.contains(answer)) {
      st.userAnswer.remove(answer);
    } else {
      if (st.userAnswer.length < st.maxChoice || st.maxChoice == 0)
        st.userAnswer.add(answer);
      else
        return false;
    }
    return true;
  }

  void updateTime(DateTime time) {
    ChoiceData st = state;
    if (time.isAfter(st.timeStart)) {
      st.timeStart = time;
    }
  }
}
