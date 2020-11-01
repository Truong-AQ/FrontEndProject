class NavigationHomeData {
  int tabIndex = 0;
  NavigationHomeData copy() {
    final clone = NavigationHomeData();
    clone.tabIndex = tabIndex;
    return clone;
  }
}
