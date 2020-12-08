class NavigationHomeData {
  int tabIndex = 0;
  String name = "";
  NavigationHomeData copy() {
    final clone = NavigationHomeData();
    clone.tabIndex = tabIndex;
    clone.name = name;
    return clone;
  }
}
