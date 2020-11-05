import 'package:project/screens/questions/choice/data.dart';
import 'package:state_notifier/state_notifier.dart';

class ChoiceController extends StateNotifier<ChoiceData> {
  ChoiceController(Map<String, dynamic> data) : super(ChoiceData(data));
}
