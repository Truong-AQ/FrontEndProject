import 'package:project/screens/questions/choice/data.dart';
import 'package:project/screens/test/data.dart';
import 'package:state_notifier/state_notifier.dart';

class ChoiceController extends StateNotifier<ChoiceData> {
  ChoiceController(Map<String, dynamic> data) : super(ChoiceData(data: data));

  bool addAnswer(AnswerChoice answer) {
    if (state.userAnswer.contains(answer)) {
      state.userAnswer.remove(answer);
    } else {
      if (state.userAnswer.length < state.maxChoice || state.maxChoice == 0)
        state.userAnswer.add(answer);
      else
        return false;
    }
    return true;
  }

  void updateTime(DateTime time) {
    if (time.isAfter(state.timeStart)) {
      state.timeStart = time;
    }
  }
}
