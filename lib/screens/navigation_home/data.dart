import 'package:flutter/widgets.dart';

class NavigationHomeData {
  NavigationHomeData(this.context);
  BuildContext context;
  int tabIndex = 0;
  NavigationHomeData copy() {
    final clone = NavigationHomeData(context);
    clone.tabIndex = tabIndex;
    return clone;
  }
}
