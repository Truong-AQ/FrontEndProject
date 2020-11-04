import 'dart:convert';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';

Future<Map<String, String>> getBasicInfo({String url}) async {
  final response = await http.get(url, headers: {'Cookie': cookie});
  String htmlResponse = response.body;
  final document = parse(htmlResponse);
  final attributes = jsonDecode(
      document.getElementsByTagName('script')[1].attributes['data-params']);
  Map<String, String> map = {};
  map['testDefinition'] = attributes['testDefinition'].replaceAll('\/', '/');
  map['testCompilation'] = attributes['testCompilation'].replaceAll('\/', '/');
  map['serviceCallId'] = attributes['serviceCallId'].replaceAll('\/', '/');
  return map;
}

Future<http.Response> initTest({Map<String, String> queryParams}) async {
  final uri = Uri.http(baseUrl, '/taoQtiTest/Runner/init', queryParams);
  final http.Response response =
      await http.post(uri, headers: {'Cookie': cookie});
  return response;
}

Future<http.Response> getItem(
    {Map<String, String> queryParams, String idItem, String token}) async {
  Map<String, String> requestQueryParams = {
    'testDefinition': queryParams['testDefinition'],
    'testCompilation': queryParams['testCompilation'],
    'testServiceCallId': queryParams['serviceCallId'],
    'itemDefinition': idItem
  };
  final uri =
      Uri.http(baseUrl, '/taoQtiTest/Runner/getItem', requestQueryParams);
  final response = await http.get(uri, headers: {
    'Cookie': cookie,
    'X-Requested-With': 'XMLHttpRequest',
    'X-Auth-Token': token
  });
  return response;
}
