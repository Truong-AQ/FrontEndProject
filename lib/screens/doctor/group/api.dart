import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';
import 'package:project/util/function/convert_response.dart';
import 'package:project/util/variable.dart';

Future<dynamic> getGroup() async {
  try {
    http.Response response = await _getGroup();
    return convertResponse1(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> getChecker({String id, String groupUri}) async {
  try {
    http.Response response = await _getChecker(id: id, groupUri: groupUri);
    return convertResponse6(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<http.Response> _getGroup() async {
  final Map<String, String> queryParams = {
    'extension': 'taoGroups',
    'perspective': 'groups',
    'section': 'manage_groups',
    'classUri': 'http://www.tao.lu/Ontologies/TAOGroup.rdf#Group',
    'hideInstances': '0',
    'filter': '*',
    'offset': '0',
    'limit': '30'
  };
  final uri =
      Uri.http(baseUrl, '/taoGroups/Groups/getOntologyData', queryParams);
  final http.Response response = await http.get(uri,
      headers: {'X-Requested-With': 'XMLHttpRequest', 'Cookie': cookie});
  return response;
}

Future<http.Response> _getChecker({String id, String groupUri}) async {
  final Map<String, String> queryParams = {
    'id': groupUri,
    'uri': id,
  };
  final uri = Uri.http(baseUrl, '/taoGroups/Groups/editGroup', queryParams);
  final http.Response response = await http.post(uri,
      headers: {'X-Requested-With': 'XMLHttpRequest', 'Cookie': cookie});
  return response;
}
