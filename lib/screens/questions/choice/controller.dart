import 'package:project/screens/questions/choice/data.dart';
import 'package:project/screens/test/data.dart';
import 'package:state_notifier/state_notifier.dart';

class ChoiceController extends StateNotifier<ChoiceData> {
  ChoiceController(Map<String, dynamic> data) : super(ChoiceData(data: data));

  void addAnswer(AnswerChoice answer) {
    if (state.userAnswer.contains(answer)) {
      state.userAnswer.remove(answer);
    } else {
      state.userAnswer.add(answer);
    }
  }

  void updateTime(DateTime time) {
    if (time.isAfter(state.timeStart)) {
      state.timeStart = time;
    }
  }
}
