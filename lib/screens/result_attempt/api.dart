import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';

  Future<http.Response> getResultTime({String classUri}) async {
  final Map<String, String> queryParams = {
    'rows': '25',
    'page': '1',
    'sortby': 'id',
    'classUri': classUri,
    'sortorder': 'asc',
    'sorttype': 'string'
  };
  final uri = Uri.http(baseUrl, '/taoOutcomeUi/Results/getResults', queryParams);
  final http.Response response = await http.get(uri, headers: {
    'Cookie': cookie
  });
  return response;
}