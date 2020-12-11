class RegisterPatientData {
  String firstName, lastName, email, loginName, password, againPassword;
  RegisterPatientData copy() {
    final clone = RegisterPatientData();
    clone.firstName = firstName;
    clone.lastName = lastName;
    clone.email = email;
    clone.loginName = loginName;
    clone.password = password;
    clone.againPassword = againPassword;
    return clone;
  }
}
