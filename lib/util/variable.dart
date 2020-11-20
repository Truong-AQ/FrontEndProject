import 'package:flutter/cupertino.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:project/resources/types.dart';
import 'package:project/screens/exercise/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;
CommonDataQuestion commonDataQuestion;
bool formatOther = false;
List<Exercise> testDone = [];
HtmlUnescape unescape = new HtmlUnescape();

AssetImage gifLoading = AssetImage('assets/images/loading.gif');
