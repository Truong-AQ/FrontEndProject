import 'package:project/resources/strings.dart';
import 'package:project/screens/splash/data.dart';
import 'package:project/util/variable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:state_notifier/state_notifier.dart';

class SplashController extends StateNotifier<SplashData> {
  SplashController() : super(SplashData());

  void initDataSet() async {
    prefs = await SharedPreferences.getInstance();
    SplashData st = state;
    await Future.delayed(Duration(milliseconds: 1500));
    st.cookie = prefs.getString('cookie') ?? '';
    cookie = st.cookie;
    st.init = true;
    if (mounted) state = st.copy();
  }
}
