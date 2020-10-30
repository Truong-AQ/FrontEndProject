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
    'Accept': 'application/json, text/javascript, */*; q=0.01',
    'Cookie':
        '__cfduid=d372b3e9b1d24672fbdffd847894732461604046887; tao_xS2lIq62=12rkm8pgivr3mgh0ltobr9thmo; tao_6e1cea3=a3f4770d2811c723e39b3fe9fe5e90e1fbc11750',
    'Accept-Encoding': 'gzip, deflate'
  });
  return response;
}
