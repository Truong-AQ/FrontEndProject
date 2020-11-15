import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';

  Future<http.Response> getResultTime({String classUri}) async {
  final Map<String, String> queryParams = {
    'extension': 'taoItems',
    'perspective': 'results',
    'section': 'manage_results',
    'classUri': classUri ?? 'http://www.tao.lu/Ontologies/TAODelivery.rdf#AssembledDelivery',
    'hideInstances': '0',
    'filter': '*',
    'offset': '0',
    'limit': '30'
  };
  final uri = Uri.http(baseUrl, '/taoOutcomeUi/Results/getResults', queryParams);
  final http.Response response = await http.get(uri, headers: {
    'Cookie': cookie
  });
  return response;
}