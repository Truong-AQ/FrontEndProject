import 'package:project/resources/strings.dart';
import 'package:project/resources/types.dart';
import 'package:project/screens/doctor/group/api.dart';
import 'api.dart' as api;
import 'data.dart';
import 'package:project/util/variable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:state_notifier/state_notifier.dart';

class LoginController extends StateNotifier<LoginData> {
  LoginController() : super(LoginData());
  Future<String> login() async {
    LoginData st = state;
    final response = await api.login(login: st.name, password: st.password);
    if (response is AppError) {
      return response.description;
    }
    final htmlBody = response.body;
    if (htmlBody.indexOf("Invalid login or password. Please try again.") !=
        -1) {
      return wrongLogin;
    } else if (htmlBody.indexOf("This field is required") != -1 ||
        htmlBody.indexOf('\'error\': ""') != -1) {
      return missLogin;
    } else {
      cookie = response.headers['set-cookie'];
      cookie = cookie.substring(cookie.indexOf('tao_xS2lIq62'));
      prefs = await SharedPreferences.getInstance();
      prefs.setString('cookie', cookie);
      return '';
    }
  }

  Future<String> getRole() async {
    LoginData st = state;
    final res = await getGroup();
    if (res is AppError && res.description != errorRoleApp) {
      return res.description;
    }
    if (res is AppError && res.description == errorRoleApp) {
      st.role = 'patient';
      if (mounted) state = st.copy();
    } else {
      st.role = 'doctor';
      if (mounted) state = st.copy();
    }
    prefs.setString('role', st.role);
    return '';
  }

  void setName(String name) {
    LoginData st = state;
    st.name = name;
  }

  void setPassword(String password) {
    LoginData st = state;
    st.password = password;
  }
}
