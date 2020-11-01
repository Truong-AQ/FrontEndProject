import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';

Future<http.Response> getTopics({String classUri}) async {
  final Map<String, String> queryParams = {
    'extension': 'taoItems',
    'perspective': 'items',
    'section': 'manage_items',
    'classUri': classUri ?? 'http://aigle.blife.ai/Aigle.rdf#i1603178372384727',
    'hideInstances': '0',
    'filter': '*',
    'offset': '0',
    'limit': '30'
  };
  final uri = Uri.http(baseUrl, '/taoItems/Items/getOntologyData', queryParams);
  final http.Response response = await http.get(uri, headers: {
    'X-Requested-With': 'XMLHttpRequest',
    'Cookie': cookie
  });
  return response;
}
