import 'package:project/screens/login/api.dart' as api;
import 'package:project/screens/login/data.dart';
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
      return 'Sai ten dang nhap hoac mat khau';
    } else if (htmlBody.indexOf("This field is required") != -1 ||
        htmlBody.indexOf('\'error\': ""') != -1) {
      return 'Vui long dien du ten dang nhap va mat khau';
    } else {
      return response.headers['set-cookie'];
    }
  }

  setName(String name) {
    state.name = name;
  }

  setPassword(String password) {
    state.password = password;
  }
}
