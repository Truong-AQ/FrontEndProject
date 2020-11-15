import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';

Future<http.Response> getResultDetail({String classUri, String id}) async {
  final Map<String, String> queryParams = {'classUri': classUri, 'id': id};
  final uri =
      Uri.http(baseUrl, '/taoOutcomeUi/Results/viewResult', queryParams);
  final http.Response response =
      await http.get(uri, headers: {'Cookie': cookie});
  return response;
}
