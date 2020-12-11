bool checkPassword(String pass) {
  if (pass.length < 4) return false;
  return RegExp(r"[A-Za-z]").hasMatch(pass);
}
