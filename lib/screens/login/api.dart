import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';
import 'package:project/util/function/convert_response.dart';

Future<dynamic> login({String login, String password}) async {
  try {
    http.Response response = await _login(login: login, password: password);
    return response;
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<http.Response> _login({String login, String password}) async {
  return await http.post(Uri.parse('http://$baseUrl/tao/Main/login'), body: {
    'loginForm_sent': "1",
    'login': login ?? '',
    'password': password ?? '',
    'connect': 'Log in'
  });
}
