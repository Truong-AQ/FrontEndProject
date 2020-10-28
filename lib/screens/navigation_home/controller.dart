import 'package:flutter/widgets.dart';
import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class NavigationHomeController extends StateNotifier<NavigationHomeData> {
  NavigationHomeController(BuildContext context)
      : super(NavigationHomeData(context));

  void updateTabIndex(int tabIndex) {
    state.tabIndex = tabIndex;
    state = state.copy();
  }
}
