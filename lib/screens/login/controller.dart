import 'package:project/resources/strings.dart';
import 'package:project/screens/login/api.dart' as api;
import 'package:project/screens/login/data.dart';
import 'package:project/util/variable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:state_notifier/state_notifier.dart';

class LoginController extends StateNotifier<LoginData> {
  LoginController() : super(LoginData());
  Future<String> login() async {
    state.process = true;
    state = state.copy();
    final response =
        await api.login(login: state.name, password: state.password);
    state.process = false;
    state = state.copy();
    final htmlBody = response.body;
    if (htmlBody.indexOf("Invalid login or password. Please try again.") !=
        -1) {
      return 'Sai tên đăng nhập hoặc mật khẩu';
    } else if (htmlBody.indexOf("This field is required") != -1 ||
        htmlBody.indexOf('\'error\': ""') != -1) {
      return 'Vui lòng điền đủ tên đăng nhập và mật khẩu';
    } else {
      cookie = response.headers['set-cookie'];
      cookie = cookie.substring(cookie.indexOf('tao_xS2lIq62'));
      prefs = await SharedPreferences.getInstance();
      prefs.setString('cookie', cookie);
      return '';
    }
  }

  setName(String name) {
    state.name = name;
  }

  setPassword(String password) {
    state.password = password;
  }
}
