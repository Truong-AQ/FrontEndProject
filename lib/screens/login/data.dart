class LoginData {
  String name, password;
  LoginData copy() {
    final clone = LoginData();
    clone.name = name;
    clone.password = password;
    return clone;
  }
}
