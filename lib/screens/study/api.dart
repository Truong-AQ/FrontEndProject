import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';
import 'package:project/util/function/convert_response.dart';
import 'package:project/util/variable.dart';

Future<dynamic> getStudy({String classUri}) async {
  try {
    final http.Response response = await _getStudy(classUri: classUri);
    return convertResponse1(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<http.Response> _getStudy({String classUri}) async {
  final Map<String, String> queryParams = {
    'extension': 'taoItems',
    'perspective': 'items',
    'section': 'manage_items',
    'classUri':
        classUri ?? 'http://aigle.blife.ai/Aigle.rdf#i160534465998506495',
    'hideInstances': '0',
    'filter': '*',
    'offset': '0',
    'limit': '30'
  };
  final uri = Uri.http(baseUrl, '/taoItems/Items/getOntologyData', queryParams);
  final http.Response response = await http.get(uri,
      headers: {'X-Requested-With': 'XMLHttpRequest', 'Cookie': cookie});
  return response;
}
