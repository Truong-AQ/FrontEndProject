import 'package:project/screens/questions/choice/data.dart';
import 'package:state_notifier/state_notifier.dart';

class ChoiceController extends StateNotifier<ChoiceData> {
  ChoiceController(Map<String, dynamic> data) : super(ChoiceData(data: data));

  void addAnswer(String id) {
    List<String> userAnswer = state.userAnswer['identifier'];
    if (userAnswer.contains(id)) {
      userAnswer.remove(id);
    } else {
      userAnswer.add(id);
    }
  }

  void updateTime(DateTime time) {
    if (time.isAfter(state.timeStart)) {
      state.timeStart = time;
    }
  }
}
