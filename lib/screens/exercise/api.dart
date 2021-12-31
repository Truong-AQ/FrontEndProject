import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';
import 'package:project/util/function/convert_response.dart';
import 'package:project/util/variable.dart';

Future<dynamic> getTests() async {
  try {
    final http.Response response = await _getTests();
    return convertResponse2(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<http.Response> _getTests() async {
  return await http.get(
      Uri.parse('http://$baseUrl/taoDelivery/DeliveryServer/index'),
      headers: {'Cookie': cookie});
}
