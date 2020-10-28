import 'package:project/screens/splash/data.dart';
import 'package:state_notifier/state_notifier.dart';

class SplashController extends StateNotifier<SplashData> {
  SplashController() : super(SplashData()) {
    Future.delayed(Duration(microseconds: 1400000)).then((value) {
      state.init = true;
      state = state.copy();
    });
  }
}
