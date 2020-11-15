import 'package:project/screens/exercise/data.dart';
import 'package:project/screens/test/data.dart';

class CommonDataQuestion {
  DateTime timeStart;
  List<AnswerChoice> userAnswer = [];
}
CommonDataQuestion commonDataQuestion;
bool formatOther = false;
List<Exercise> testDone = [];