import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';
import 'package:project/util/variable.dart';
import 'data.dart';
import 'package:project/util/function/convert_response.dart';

Future<dynamic> addInstance() async {
  try {
    http.Response response = await _addInstance();
    return convertResponse1(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> getToken(NewTestData dt) async {
  try {
    http.Response response = await _getToken(dt);
    return convertResponse8(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> updateInfo(NewTestData dt) async {
  try {
    http.Response response = await _updateInfo(dt);
    if (response.body == '') return '';
    return convertResponse2(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<http.Response> _addInstance() async {
  return await http
      .post('http://$baseUrl/taoTests/Tests/addInstance', headers: {
    'cookie': cookie,
    'X-Requested-With': 'XMLHttpRequest'
  }, body: {
    'classUri': 'http_2_www_0_tao_0_lu_1_Ontologies_1_TAOTest_0_rdf_3_Test',
    'id': 'http://www.tao.lu/Ontologies/TAOTest.rdf#Test',
    'type': 'instance'
  });
}

Future<http.Response> _getToken(NewTestData dt) async {
  return await http.post('http://$baseUrl/taoTests/Tests/editTest', headers: {
    'cookie': cookie,
    'X-Requested-With': 'XMLHttpRequest'
  }, body: {
    'classUri': 'http_2_www_0_tao_0_lu_1_Ontologies_1_TAOTest_0_rdf_3_Test',
    'uri': dt.id,
    'id': dt.uri
  });
}

Future<http.Response> _updateInfo(NewTestData dt) async {
  Map<String, String> bodyParam = {};
  bodyParam['form_1_sent'] = '1';
  bodyParam['tao.forms.instance'] = '1';
  bodyParam['token'] = dt.token;
  bodyParam['http_2_www_0_w3_0_org_1_2000_1_01_1_rdf-schema_3_label'] = dt.name;
  bodyParam['classUri'] =
      'http_2_www_0_tao_0_lu_1_Ontologies_1_TAOTest_0_rdf_3_Test';
  bodyParam[
          'http_2_www_0_tao_0_lu_1_Ontologies_1_TAOTest_0_rdf_3_TestTestModel'] =
      'http_2_www_0_tao_0_lu_1_Ontologies_1_TAOTest_0_rdf_3_QtiTestModel';
  bodyParam['id'] = dt.uri;
  bodyParam['uri'] = dt.id;
  final uri = Uri.http(baseUrl, '/taoTests/Tests/editTest');
  final http.Response response = await http.post(uri,
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Cookie': cookie,
        'Accept': 'text/html, */*; q=0.01'
      },
      body: bodyParam);
  return response;
}
