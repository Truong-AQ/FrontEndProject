import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';
import 'package:project/util/function/convert_response.dart';

Future<dynamic> getResult({String classUri}) async {
  try {
    final http.Response response = await _getResult(classUri: classUri);
    return convertResponse1(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<http.Response> _getResult({String classUri}) async {
  final Map<String, String> queryParams = {
    'extension': 'taoOutcomeUi',
    'perspective': 'results',
    'section': 'manage_results',
    'classUri': classUri ??
        'http://www.tao.lu/Ontologies/TAODelivery.rdf#AssembledDelivery',
    'hideInstances': '0',
    'filter': '*',
    'offset': '0',
    'limit': '30'
  };
  final uri = Uri.http(
      baseUrl, '/taoDeliveryRdf/DeliveryMgmt/getOntologyData', queryParams);
  final http.Response response = await http.get(uri,
      headers: {'X-Requested-With': 'XMLHttpRequest', 'Cookie': cookie});
  return response;
}
