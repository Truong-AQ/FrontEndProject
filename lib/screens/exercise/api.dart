import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';

Future<http.Response> getTests() async {
  final response = await http.get(
      'http://$baseUrl/taoDelivery/DeliveryServer/index',
      headers: {'Cookie': cookie});
  return response;
}
