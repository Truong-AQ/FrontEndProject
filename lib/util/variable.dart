import 'package:flutter/cupertino.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:project/resources/strings.dart';
import 'package:project/resources/types.dart';
import 'package:project/screens/patient/exercise/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;
String cookie = '', nameTestTaker = '';
BuildContext contextLogin, contextHome;
CommonDataQuestion commonDataQuestion;
bool formatOther = false;
List<Exercise> testOfUser = [];
HtmlUnescape unescape = new HtmlUnescape();

AssetImage gifLoading = AssetImage(urlIconLoading);
