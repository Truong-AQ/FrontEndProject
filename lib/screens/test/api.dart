import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';
import 'package:project/screens/test/data.dart';
import 'package:project/util/function/convert_response.dart';
import 'package:project/util/variable.dart';

Future<dynamic> getBasicInfo({String url}) async {
  try {
    final http.Response response = await _getBasicInfo(url: url);
    return convertResponse4(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> initTest({Map<String, String> queryParams}) async {
  try {
    final http.Response response = await _initTest(queryParams: queryParams);
    return convertResponse2(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> getItem(
    {Map<String, String> queryParams, String idItem, String token}) async {
  try {
    final http.Response response =
        await _getItem(queryParams: queryParams, idItem: idItem, token: token);
    return convertResponse1(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> moveItem(
    {TypeQuestion typeQuestion,
    Map<String, dynamic> listChoice,
    Map<String, String> queryParams,
    String idItem,
    double timeDuration,
    String token}) async {
  try {
    final http.Response response = await _moveItem(
        typeQuestion: typeQuestion,
        listChoice: listChoice,
        queryParams: queryParams,
        idItem: idItem,
        timeDuration: timeDuration,
        token: token);
    return convertResponse1(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<http.Response> _getBasicInfo({String url}) async {
  final response = await http.get(url, headers: {'Cookie': cookie});
  return response;
}

Future<http.Response> _initTest({Map<String, String> queryParams}) async {
  final uri = Uri.http(baseUrl, '/taoQtiTest/Runner/init', queryParams);
  final http.Response response =
      await http.post(uri, headers: {'Cookie': cookie});
  return response;
}

Future<http.Response> _getItem(
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

Future<http.Response> _moveItem(
    {TypeQuestion typeQuestion,
    Map<String, dynamic> listChoice,
    Map<String, String> queryParams,
    String idItem,
    double timeDuration,
    String token}) async {
  Map<String, String> requestQueryParams = {
    'testDefinition': queryParams['testDefinition'],
    'testCompilation': queryParams['testCompilation'],
    'testServiceCallId': queryParams['serviceCallId'],
    'itemDefinition': idItem
  };
  final uri = Uri.http(baseUrl, '/taoQtiTest/Runner/move', requestQueryParams);
  final response = await http.post(uri, headers: {
    'Cookie': cookie,
    'X-Requested-With': 'XMLHttpRequest',
    'X-Auth-Token': token
  }, body: {
    'direction': 'next',
    'scope': 'item',
    'itemResponse':
        _createItemForMoveItem(list: listChoice, extra: 'response').toString(),
    'itemState':
        _createItemForMoveItem(list: listChoice, extra: 'state').toString(),
    'itemDuration': '$timeDuration'
  });
  return response;
}

Map<String, dynamic> _createItemForMoveItem(
    {Map<String, dynamic> list, String extra}) {
  Map<String, dynamic> tmp = {}, item = {}, tmp2 = {}, tmp3 = {};
  if (!formatOther)
    tmp['"list"'] = list;
  else {
    if (list['"identifier"'].length > 0)
      tmp3['"identifier"'] = list['"identifier"'][0];
    else
      tmp3['"identifier"'] = {};
    tmp['"base"'] = tmp3;
  }
  if (extra == 'state') {
    tmp2['"response"'] = tmp;
    item['"RESPONSE"'] = tmp2;
  } else {
    item['"RESPONSE"'] = tmp;
  }

  return item;
}
