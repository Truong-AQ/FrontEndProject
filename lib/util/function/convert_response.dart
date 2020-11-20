import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';
import 'package:project/resources/types.dart';

dynamic convertResponse1(http.Response response) {
  final json = jsonDecode(response.body);
  if (json['message'] == cookieInvalid)
    return AppError(description: cookieExpired);
  else
    return json;
}

dynamic convertResponse2(http.Response response) {
  final body = response.body;
  if (body == '' && response.headers.length == 12)
    return AppError(description: cookieExpired);
  else if (body == '') return AppError(description: clientError);
  return body;
}

dynamic convertResponse4(http.Response response) {
  String htmlResponse = response.body;
  final document = parse(htmlResponse);
  final attributes = jsonDecode(
      document.getElementsByTagName('script')[1].attributes['data-params']);
  if (attributes == null) {
    return AppError(description: cookieExpired);
  }
  Map<String, String> map = {};
  map['testDefinition'] = attributes['testDefinition'].replaceAll('\/', '/');
  map['testCompilation'] = attributes['testCompilation'].replaceAll('\/', '/');
  map['serviceCallId'] = attributes['serviceCallId'].replaceAll('\/', '/');
  return map;
}

dynamic convertResponse5(http.Response response) {
  String htmlFindLink = response.body;
  int posDecision1 = htmlFindLink.indexOf('previewUrl');
  if (posDecision1 == -1) return AppError(description: cookieExpired);
  while (htmlFindLink[posDecision1] != 'h') {
    posDecision1++;
  }

  int posDecision2 = posDecision1;
  while (htmlFindLink[posDecision2] != '"') {
    posDecision2++;
  }
  String link =
      htmlFindLink.substring(posDecision1, posDecision2).replaceAll('\\/', '/');
  return link;
}

dynamic convertResponse6(http.Response response) {
  String htmlInfo = response.body;
  int posDecision1 = htmlInfo.indexOf('itemData');
  if (posDecision1 == -1) return AppError(description: cookieExpired);
  int posDecision2 = htmlInfo.indexOf('apipAccessibility');
  while (htmlInfo[posDecision1] != '{') {
    posDecision1++;
  }
  while (htmlInfo[posDecision2] != ',') {
    posDecision2++;
  }
  final json = jsonDecode(
      htmlInfo.substring(posDecision1, posDecision2).replaceAll('\\/', '/'));
  return json;
}

dynamic convertResponseException(Exception e) {
  if (e is SocketException)
    return AppError(description: noNetwork);
  else if (e is http.ClientException) return AppError(description: clientError);
}

bool checkResponseError(dynamic response, InfoError st) {
  if (st.error != '') return false;
  if (response is AppError) {
    st.error = response.description;
    st.numOfError += 1;
    return false;
  }
  return true;
}
