import 'package:project/resources/strings.dart';
import 'package:project/screens/splash/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:state_notifier/state_notifier.dart';

class SplashController extends StateNotifier<SplashData> {
  SplashController() : super(SplashData());

  void initDataSet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 1));
    state.cookie = prefs.getString('cookie') ?? '';
    cookie = state.cookie;
    state.init = true;
    state = state.copy();
  }
}
