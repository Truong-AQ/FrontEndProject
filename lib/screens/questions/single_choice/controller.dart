import 'package:project/screens/questions/single_choice/data.dart';
import 'package:state_notifier/state_notifier.dart';

class SingleChoiceController extends StateNotifier<SingleChoiceData> {
  SingleChoiceController() : super(SingleChoiceData());

  setAnswer(String answer) {
    state.answerChoice = answer;
    state.isCorrect = (state.answerCorrect == answer);
    state = state.copy();
  }
}
