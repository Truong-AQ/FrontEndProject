import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';
import 'package:project/util/function/convert_response.dart';

Future<dynamic> getLink({String uri}) async {
  try {
    final http.Response response = await _getLink(uri: uri);
    return response.body == '' && response.headers.length != 12
        ? getLink(uri: uri)
        : convertResponse5(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> getInfoObjectItem({String link}) async {
  try {
    final http.Response response = await _getInfoObjectItem(link: link);
    return response.body == '' && response.headers.length != 12
        ? getInfoObjectItem(link: link)
        : convertResponse6(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<http.Response> _getLink({String uri}) async {
  final http.Response response = await http.post(
      'http://$baseUrl/taoItems/ItemPreview/forwardMe',
      headers: {'X-Requested-With': 'XMLHttpRequest', 'Cookie': cookie},
      body: {'uri': uri});
  return response;
}

Future<http.Response> _getInfoObjectItem({String link}) async {
  final http.Response response =
      await http.get(link, headers: {'Cookie': cookie});
  return response;
}
