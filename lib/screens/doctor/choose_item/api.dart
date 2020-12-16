import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';
import 'package:project/util/function/convert_response.dart';
import 'package:project/util/variable.dart';

Future<dynamic> getTest({String uri}) async {
  try {
    http.Response response = await _getTest(uri: uri);
    return convertResponse1(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> getItems({String classUri}) async {
  try {
    http.Response response = await _geItems(classUri: classUri);
    return convertResponse1(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> saveQuestions({String model, String dataUri}) async {
  try {
    http.Response response =
        await _saveQuestions(dataUri: dataUri, model: model);
    return convertResponse1(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<http.Response> _getTest({String uri}) async {
  final Map<String, String> queryParams = {'uri': uri};
  // ignore: non_constant_identifier_names
  final URI = Uri.http(baseUrl, '/taoQtiTest/Creator/getTest', queryParams);
  final http.Response response = await http.get(URI,
      headers: {'X-Requested-With': 'XMLHttpRequest', 'Cookie': cookie});
  return response;
}

Future<http.Response> _geItems({String classUri}) async {
  final Map<String, String> queryParams = {
    'classUri': classUri ?? 'http://aigle.blife.ai/Aigle.rdf#i1603178372384727',
    'format': 'tree',
    'limit': '1000',
    'search': '{"http://www.w3.org/2000/01/rdf-schema#label":""}'
  };
  final uri = Uri.http(baseUrl, '/taoQtiTest/Items/getItems', queryParams);
  final http.Response response = await http.get(uri,
      headers: {'X-Requested-With': 'XMLHttpRequest', 'Cookie': cookie});
  return response;
}

Future<http.Response> _saveQuestions({String model, String dataUri}) async {
  Map<String, String> params = {'uri': dataUri};
  final url = Uri.http(baseUrl, '/taoQtiTest/Creator/saveTest', params);
  return http.post(url, headers: {
    'Cookie': cookie,
    'X-Requested-With': 'XMLHttpRequest',
    'Accept': '*/*'
  }, body: {
    'model': model
  });
}
