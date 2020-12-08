import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class NavigationHomeController extends StateNotifier<NavigationHomeData> {
  NavigationHomeController() : super(NavigationHomeData());

  void updateTabIndex(int tabIndex) {
    NavigationHomeData st = state;
    st.tabIndex = tabIndex;
    if (mounted) state = st.copy();
  }

  void updateName(String name) {
    NavigationHomeData st = state;
    st.name = name;
    if (mounted) state = st.copy();
  }
}
