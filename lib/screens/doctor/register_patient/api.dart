import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';
import 'package:project/util/variable.dart';
import 'data.dart';
import 'package:project/util/function/convert_response.dart';

Future<dynamic> addInstance() async {
  try {
    http.Response response = await _addInstance();
    print('addInstance: ${response.body}');
    return convertResponse1(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> checkLogin(String loginName) async {
  try {
    http.Response response = await _checkLogin(loginName);
    print('checkLogin: ${response.body}');
    return convertResponse1(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> getToken(RegisterPatientData dt) async {
  try {
    http.Response response = await _getToken(dt);
    print('getToken: ${response.body}');
    return convertResponse8(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> updateInfo(RegisterPatientData dt) async {
  try {
    http.Response response = await _updateInfo(dt);
    print('updateInfo: ${response.body}');
    if (response.body == '') return '';
    return convertResponse2(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> getTokenUser(RegisterPatientData dt) async {
  try {
    http.Response response = await _getTokenUser(dt);
    print('getTokenUser: ${response.body}');
    return convertResponse8(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> updateInfoUser(RegisterPatientData dt) async {
  try {
    http.Response response = await _updateInfoUser(dt);
    print('updateInfoUser: ${response.body}');
    if (response.body == '') return '';
    return convertResponse2(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<http.Response> _addInstance() async {
  return await http
      .post('http://$baseUrl/taoTestTaker/TestTaker/addInstance', headers: {
    'cookie': cookie,
    'X-Requested-With': 'XMLHttpRequest'
  }, body: {
    'classUri':
        'http_2_www_0_tao_0_lu_1_Ontologies_1_TAOSubject_0_rdf_3_Subject',
    'id': 'http://www.tao.lu/Ontologies/TAOSubject.rdf#Subject',
    'type': 'instance'
  });
}

Future<http.Response> _checkLogin(String loginName) async {
  return await http.post('http://$baseUrl/tao/Users/checkLogin',
      headers: {'cookie': cookie, 'X-Requested-With': 'XMLHttpRequest'},
      body: {'login': loginName});
}

Future<http.Response> _getToken(RegisterPatientData dt) async {
  return await http
      .post('http://$baseUrl/taoTestTaker/TestTaker/editSubject', headers: {
    'cookie': cookie,
    'X-Requested-With': 'XMLHttpRequest'
  }, body: {
    'classUri':
        'http_2_www_0_tao_0_lu_1_Ontologies_1_TAOSubject_0_rdf_3_Subject',
    'uri': dt.id,
    'id': dt.uri
  });
}

Future<http.Response> _updateInfo(RegisterPatientData dt) async {
  Map<String, String> bodyParam = {};
  bodyParam['user_form_sent'] = '1';
  bodyParam['tao.forms.instance'] = '1';

  bodyParam['token'] = dt.token;
  bodyParam['http_2_www_0_w3_0_org_1_2000_1_01_1_rdf-schema_3_label'] =
      dt.label;
  bodyParam['id'] = dt.uri;
  bodyParam[
      'http_2_www_0_tao_0_lu_1_Ontologies_1_generis_0_rdf_3_userFirstName'] = dt
          .firstName ??
      '';
  bodyParam[
          'http_2_www_0_tao_0_lu_1_Ontologies_1_generis_0_rdf_3_userLastName'] =
      dt.lastName ?? '';
  bodyParam['http_2_www_0_tao_0_lu_1_Ontologies_1_generis_0_rdf_3_userMail'] =
      dt.email ?? '';
  bodyParam['http_2_www_0_tao_0_lu_1_Ontologies_1_generis_0_rdf_3_userUILg'] =
      'http_2_www_0_tao_0_lu_1_Ontologies_1_TAO_0_rdf_3_Langvi-VN';
  bodyParam['http_2_www_0_tao_0_lu_1_Ontologies_1_generis_0_rdf_3_login'] =
      dt.loginName;
  bodyParam['uri'] = dt.id;
  bodyParam['classUri'] =
      'http_2_www_0_tao_0_lu_1_Ontologies_1_TAOSubject_0_rdf_3_Subject';
  bodyParam['password1'] = dt.password;
  bodyParam['password2'] = dt.againPassword;
  final uri = Uri.http(baseUrl, '/taoTestTaker/TestTaker/editSubject');
  final http.Response response = await http.post(uri,
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Cookie': cookie,
        'Accept': 'text/html, */*; q=0.01'
      },
      body: bodyParam);
  return response;
}

Future<http.Response> _getTokenUser(RegisterPatientData dt) async {
  return await http.post('http://$baseUrl/tao/Users/edit', headers: {
    'cookie': cookie,
    'X-Requested-With': 'XMLHttpRequest'
  }, body: {
    'uri': dt.id,
  });
}

Future<http.Response> _updateInfoUser(RegisterPatientData dt) async {
  Map<String, String> bodyParam = {};
  bodyParam['user_form_sent'] = '1';
  bodyParam['tao.forms.instance'] = '1';

  bodyParam['token'] = dt.token;
  bodyParam['http_2_www_0_w3_0_org_1_2000_1_01_1_rdf-schema_3_label'] =
      dt.label;
  bodyParam['id'] = dt.uri;
  bodyParam[
      'http_2_www_0_tao_0_lu_1_Ontologies_1_generis_0_rdf_3_userFirstName'] = dt
          .firstName ??
      '';
  bodyParam[
          'http_2_www_0_tao_0_lu_1_Ontologies_1_generis_0_rdf_3_userLastName'] =
      dt.lastName ?? '';
  bodyParam['http_2_www_0_tao_0_lu_1_Ontologies_1_generis_0_rdf_3_userMail'] =
      dt.email ?? '';
  bodyParam['http_2_www_0_tao_0_lu_1_Ontologies_1_generis_0_rdf_3_userUILg'] =
      'http_2_www_0_tao_0_lu_1_Ontologies_1_TAO_0_rdf_3_Langvi-VN';
  bodyParam['http_2_www_0_tao_0_lu_1_Ontologies_1_generis_0_rdf_3_login'] =
      dt.loginName;
  bodyParam['uri'] = dt.id;
  bodyParam['classUri'] =
      'http_2_www_0_tao_0_lu_1_Ontologies_1_TAOSubject_0_rdf_3_Subject';
  bodyParam['password2'] = dt.password;
  bodyParam['password3'] = dt.againPassword;
  bodyParam[
          'http_2_www_0_tao_0_lu_1_Ontologies_1_generis_0_rdf_3_userRoles_1'] =
      'http_2_www_0_tao_0_lu_1_Ontologies_1_TAOItem_0_rdf_3_ItemAuthor';
  bodyParam[
          'http_2_www_0_tao_0_lu_1_Ontologies_1_generis_0_rdf_3_userRoles_4'] =
      'http_2_www_0_tao_0_lu_1_Ontologies_1_TAO_0_rdf_3_RestPublisher';
  bodyParam[
          'http_2_www_0_tao_0_lu_1_Ontologies_1_generis_0_rdf_3_userRoles_5'] =
      'http_2_www_0_tao_0_lu_1_Ontologies_1_TAOResult_0_rdf_3_TaoReviewerRole';
  bodyParam[
          'http_2_www_0_tao_0_lu_1_Ontologies_1_generis_0_rdf_3_userRoles_8'] =
      'http_2_www_0_tao_0_lu_1_Ontologies_1_TAO_0_rdf_3_DeliveryRole';
  final uri = Uri.http(baseUrl, '/tao/Users/edit');
  final http.Response response = await http.post(uri,
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Cookie': cookie,
        'Accept': 'text/html, */*; q=0.01'
      },
      body: bodyParam);
  return response;
}
