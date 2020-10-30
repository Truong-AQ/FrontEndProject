import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';

Future<http.Response> login({String login, String password}) async {
  final http.Response response =
      await http.post('http://$baseUrl/tao/Main/login', body: {
    'loginForm_sent': "1",
    'login': login ?? '',
    'password': password ?? '',
    'connect': 'Log in'
  });
  return response;
}
