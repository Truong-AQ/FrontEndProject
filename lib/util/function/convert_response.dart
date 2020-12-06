import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';
import 'package:project/resources/types.dart';

dynamic convertResponse1(http.Response response) {
  final json = jsonDecode(response.body);
  if (json['message'] == cookieExpiredServer)
    return AppError(description: cookieExpiredApp);
  else if (json['message'] == errorRoleServer) {
    return AppError(description: errorRoleApp);
  } else
    return json;
}

dynamic convertResponse2(http.Response response) {
  final body = response.body;
  if (body == '' && response.headers.length == 12)
    return AppError(description: cookieExpiredApp);
  else if (body == '') return AppError(description: clientError);
  return body;
}

dynamic convertResponse3(http.Response response) {
  String htmlResponse = response.body;
  final document = parse(htmlResponse);
  final script = document.getElementsByTagName('script');
  if (script.length < 2) return AppError(description: cookieExpiredApp);
  final attributes = jsonDecode(script[1].attributes['data-params']);
  if (attributes == null) {
    return AppError(description: cookieExpiredApp);
  }
  Map<String, String> map = {};
  map['testDefinition'] = attributes['testDefinition'].replaceAll('\/', '/');
  map['testCompilation'] = attributes['testCompilation'].replaceAll('\/', '/');
  map['serviceCallId'] = attributes['serviceCallId'].replaceAll('\/', '/');
  return map;
}

dynamic convertResponse4(http.Response response) {
  String htmlFindLink = response.body;
  int posDecision1 = htmlFindLink.indexOf('previewUrl');
  if (posDecision1 == -1) return AppError(description: cookieExpiredApp);
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

dynamic convertResponse5(http.Response response) {
  String htmlInfo = response.body;
  int posDecision1 = htmlInfo.indexOf('itemData');
  if (posDecision1 == -1) return AppError(description: cookieExpiredApp);
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

dynamic convertResponse6(http.Response response) {
  final html = response.body;
  if (html.contains(cookieExpiredServer))
    return AppError(description: cookieExpiredApp);
  else if (html.contains(errorRoleServer))
    return AppError(description: errorRoleApp);
  final htmlParse = parse(html);
  Map<String, List> checker = {};
  List scripts = htmlParse.getElementsByTagName('script');
  //test taker checker
  checker['test-taker'] = [];
  String htmlTestTaker = scripts[1].toString();
  int l = htmlTestTaker.length;
  int pos = htmlTestTaker.indexOf('checkedNodes');
  for (int i = pos; i < l; i++) {
    if (htmlTestTaker[i] == '"') {
      for (int j = i + 1; j < l; j++)
        if (htmlTestTaker[j] == '"') {
          checker['test-taker'].add(htmlTestTaker.substring(i + 1, j));
          i = j;
          break;
        } else if (htmlTestTaker[i] == ']') break;
    }
  }
  //test checker
  checker['test'] = [];
  String htmlTest = scripts[2].toString();
  l = htmlTest.length;
  pos = htmlTest.indexOf('checkedNodes');
  for (int i = pos; i < l; i++) {
    if (htmlTest[i] == '"') {
      for (int j = i + 1; j < l; j++)
        if (htmlTest[j] == '"') {
          checker['test'].add(htmlTest.substring(i + 1, j));
          i = j;
          break;
        } else if (htmlTest[i] == ']') break;
    }
  }
  return checker;
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
