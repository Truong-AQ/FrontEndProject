class SplashData {
  bool init = false;
  String cookie = '', role = '';
  SplashData copy() {
    SplashData clone = SplashData();
    clone.init = init;
    clone.cookie = cookie;
    clone.role = role;
    return clone;
  }
}
