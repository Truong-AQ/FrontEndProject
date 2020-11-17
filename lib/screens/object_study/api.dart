import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';

Future<http.Response> getLink({String uri}) async {
  final http.Response response = await http.post(
      'http://$baseUrl/taoItems/ItemPreview/forwardMe',
      headers: {'X-Requested-With': 'XMLHttpRequest', 'Cookie': cookie},
      body: {'uri': uri});
  return response;
}

Future<http.Response> getInfoObjectItem({String link}) async {
  final http.Response response =
      await http.get(link, headers: {'Cookie': cookie});
  return response;
}