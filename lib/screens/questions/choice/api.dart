import 'package:http/http.dart' as http;

const baseUrl = 'http://aigle.blife.ai/';
Future<http.Response> login({String login, String password}) async {
  final http.Response response = await http.post('${baseUrl}tao/Main/login',
      body: {
        'loginForm_sent': "1",
        'login': login ?? '',
        'password': password ?? '',
        'connect': 'Log in'
      });
  return response;
}