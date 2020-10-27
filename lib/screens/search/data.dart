class LoginData {
  String name, password;
  bool process = false;
  LoginData copy() {
    final clone = LoginData();
    clone.name = name;
    clone.password = password;
    clone.process = process;
    return clone;
  }
}
