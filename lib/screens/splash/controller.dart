import 'package:project/resources/strings.dart';
import 'package:project/screens/splash/data.dart';
import 'package:project/util/variable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:state_notifier/state_notifier.dart';

class SplashController extends StateNotifier<SplashData> {
  SplashController() : super(SplashData());

  void initDataSet() async {
    prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(milliseconds: 1500));
    state.cookie = prefs.getString('cookie') ?? '';
    cookie = state.cookie;
    state.init = true;
    state = state.copy();
  }
}
