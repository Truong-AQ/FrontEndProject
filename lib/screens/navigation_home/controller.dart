import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class NavigationHomeController extends StateNotifier<NavigationHomeData> {
  NavigationHomeController() : super(NavigationHomeData());

  void updateTabIndex(int tabIndex) {
    state.tabIndex = tabIndex;
    state = state.copy();
  }
}
