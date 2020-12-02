class SplashData {
  bool init = false;
  String cookie = '';
  SplashData copy() {
    SplashData clone = SplashData();
    clone.init = init;
    clone.cookie = cookie;
    return clone;
  }
}
