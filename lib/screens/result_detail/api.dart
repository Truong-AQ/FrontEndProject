import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';
import 'package:project/util/function/convert_response.dart';

Future<dynamic> getResultDetail({String classUri, String id}) async {
  try {
    final http.Response response =
        await _getResultDetail(classUri: classUri, id: id);
    return convertResponse2(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<http.Response> _getResultDetail({String classUri, String id}) async {
  final Map<String, String> queryParams = {'classUri': classUri, 'id': id};
  final uri =
      Uri.http(baseUrl, '/taoOutcomeUi/Results/viewResult', queryParams);
  final http.Response response =
      await http.get(uri, headers: {'Cookie': cookie});
  return response;
}
