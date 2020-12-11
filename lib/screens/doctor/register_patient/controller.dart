import 'data.dart';
import 'package:state_notifier/state_notifier.dart';

class RegisterPatientController extends StateNotifier<RegisterPatientData> {
  RegisterPatientController() : super(RegisterPatientData());
  Future<String> register() async {
    RegisterPatientData st = state;
    return '';
  }

  void setFirstName(String firstName) {
    RegisterPatientData st = state;
    st.firstName = firstName;
  }

  void setLastName(String lastName) {
    RegisterPatientData st = state;
    st.lastName = lastName;
  }

  void setLoginName(String loginName) {
    RegisterPatientData st = state;
    st.loginName = loginName;
  }

  void setAgainPassword(String againPassword) {
    RegisterPatientData st = state;
    st.againPassword = againPassword;
  }

  void setPassword(String password) {
    RegisterPatientData st = state;
    st.password = password;
  }

  void setEmail(String email) {
    RegisterPatientData st = state;
    st.email = email;
  }
}
