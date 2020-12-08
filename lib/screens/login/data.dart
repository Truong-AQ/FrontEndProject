class LoginData {
  String name, password, role;
  LoginData copy() {
    final clone = LoginData();
    clone.name = name;
    clone.password = password;
    clone.role = role;
    return clone;
  }
}
