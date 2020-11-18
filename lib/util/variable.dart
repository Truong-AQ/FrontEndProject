import 'package:html_unescape/html_unescape.dart';
import 'package:project/resources/app_context.dart';
import 'package:project/resources/strings.dart';
import 'package:project/screens/exercise/data.dart';
import 'package:project/screens/test/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonDataQuestion {
  DateTime timeStart;
  List<AnswerChoice> userAnswer = [];
}
SharedPreferences prefs;
CommonDataQuestion commonDataQuestion;
bool formatOther = false;
List<Exercise> testDone = [];
HtmlUnescape unescape = new HtmlUnescape();
void freeVariable() {
  commonDataQuestion = null;
  contextHome = null;
  testDone = [];
  prefs = null;
  cookie = '';
  nameTestTaker = '';
}