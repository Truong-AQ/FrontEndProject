class SplashData {
  bool init = false;
  SplashData copy() {
    SplashData clone = SplashData();
    clone.init = init;
    return clone;
  }
}
