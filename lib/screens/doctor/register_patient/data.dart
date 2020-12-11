class RegisterPatientData {
  String firstName,
      lastName,
      email,
      loginName,
      password,
      againPassword,
      label,
      token,
      id,
      uri;
  RegisterPatientData copy() {
    final clone = RegisterPatientData();
    clone.firstName = firstName;
    clone.lastName = lastName;
    clone.email = email;
    clone.loginName = loginName;
    clone.password = password;
    clone.againPassword = againPassword;
    clone.label = label;
    clone.uri = uri;
    clone.token = token;
    clone.id = id;
    return clone;
  }
}
