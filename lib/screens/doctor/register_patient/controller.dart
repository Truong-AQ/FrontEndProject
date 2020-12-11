import 'dart:convert';

import 'package:project/resources/strings.dart';
import 'package:project/resources/types.dart';
import 'package:project/screens/doctor/register_patient/api.dart';
import 'package:project/util/function/check_pass.dart';

import 'data.dart';
import 'package:state_notifier/state_notifier.dart';

class RegisterPatientController extends StateNotifier<RegisterPatientData> {
  RegisterPatientController() : super(RegisterPatientData());
  Future<String> register() async {
    RegisterPatientData st = state;
    if ((st.password == null && st.againPassword == null) ||
        st.loginName == null) return missLogin;
    if (st.password != st.againPassword) {
      return noMatchPassword;
    }
    if (!checkPassword(st.password)) return passwordNoValid;
    var res = await checkLogin(st.loginName);
    if (res is AppError) return res.description;
    if (!res['available']) return userExist;
    res = await addInstance();
    if (res is AppError) return res.description;
    st.uri = res['uri'].replaceAll('\\/', '/');
    st.label = res['label'];
    st.id = st.uri
        .replaceAll('://', '_2_')
        .replaceAll('.', '_0_')
        .replaceAll('/', '_1_')
        .replaceAll('#', '_3_');
    res = await getToken(st);
    if (res is AppError) return res.description;
    st.token = res;
    res = await updateInfo(st);
    if (res is AppError) return res.description;
    res = await getTokenUser(st);
    if (res is AppError) return res.description;
    st.token = res;
    res = await updateInfoUser(st);
    if (res is AppError) return res.description;
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
