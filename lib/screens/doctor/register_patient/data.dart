class RegisterPatientData {
  String name, password, role;
  RegisterPatientData copy() {
    final clone = RegisterPatientData();
    clone.name = name;
    clone.password = password;
    clone.role = role;
    return clone;
  }
}
