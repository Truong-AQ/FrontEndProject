import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';
import 'package:project/util/function/convert_response.dart';

Future<dynamic> getResultTime({String classUri, int page}) async {
  try {
    final http.Response response =
        await _getResultTime(classUri: classUri, page: page);
    return convertResponse2(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<http.Response> _getResultTime({String classUri, int page}) async {
  final Map<String, String> queryParams = {
    'rows': '50',
    'page': '$page',
    'sortby': 'id',
    'classUri': classUri,
    'sortorder': 'asc',
    'sorttype': 'string'
  };
  final uri =
      Uri.http(baseUrl, '/taoOutcomeUi/Results/getResults', queryParams);
  final http.Response response =
      await http.get(uri, headers: {'Cookie': cookie});
  return response;
}
