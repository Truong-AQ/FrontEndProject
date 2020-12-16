import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';
import 'package:project/util/variable.dart';
import 'data.dart';
import 'package:project/util/function/convert_response.dart';

Future<dynamic> addInstance({String idNameTestAssign}) async {
  try {
    http.Response response =
        await _addInstance(idNameTestAssign: idNameTestAssign);
    return convertResponse1(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> getIdAssign({String idTmp}) async {
  try {
    http.Response response = await _getIdAssign(idTmp: idTmp);
    return convertResponse1(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> searchTest({String searchText}) async {
  try {
    http.Response response = await _searchTest();
    return convertResponse1(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> getToken(NewAssignTestData dt) async {
  try {
    http.Response response = await _getToken(dt);
    return convertResponse8(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> updateInfo(NewAssignTestData dt) async {
  try {
    http.Response response = await _updateInfo(dt);
    if (response.body == '') return '';
    return convertResponse2(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<http.Response> _addInstance({String idNameTestAssign}) async {
  return await http
      .post('http://$baseUrl/taoDeliveryRdf/DeliveryMgmt/wizard', headers: {
    'cookie': cookie,
    'X-Requested-With': 'XMLHttpRequest'
  }, body: {
    'simpleWizard_sent': '1',
    'classUri':
        'http://www.tao.lu/Ontologies/TAODelivery.rdf#AssembledDelivery',
    'test': idNameTestAssign
  });
}

Future<http.Response> _getIdAssign({String idTmp}) async {
  Map<String, String> params = {'taskId': idTmp};
  final uri = Uri.http(baseUrl, '/tao/TaskQueueWebApi/get', params);
  return await http.get(uri,
      headers: {'cookie': cookie, 'X-Requested-With': 'XMLHttpRequest'});
}

Future<http.Response> _searchTest({String searchText}) async {
  Map<String, String> params = {'q': searchText, 'page': '1'};
  final uri = Uri.http(
      baseUrl, '/taoDeliveryRdf/DeliveryMgmt/getAvailableTests', params);
  return await http.get(uri,
      headers: {'cookie': cookie, 'X-Requested-With': 'XMLHttpRequest'});
}

Future<http.Response> _getToken(NewAssignTestData dt) async {
  return await http.post(
      'http://$baseUrl/taoDeliveryRdf/DeliveryMgmt/editDelivery',
      headers: {
        'cookie': cookie,
        'X-Requested-With': 'XMLHttpRequest'
      },
      body: {
        'classUri':
            'http_2_www_0_tao_0_lu_1_Ontologies_1_TAODelivery_0_rdf_3_AssembledDelivery',
        'uri': dt.uri,
        'id': dt.id
      });
}

Future<http.Response> _updateInfo(NewAssignTestData dt) async {
  Map<String, String> bodyParam = {};
  bodyParam['form_1_sent'] = '1';
  bodyParam['tao.forms.instance'] = '1';

  bodyParam['token'] = dt.token;
  bodyParam['http_2_www_0_w3_0_org_1_2000_1_01_1_rdf-schema_3_label'] =
      dt.title;
  bodyParam['id'] = dt.id;
  bodyParam[
          'http_2_www_0_tao_0_lu_1_Ontologies_1_TAODelivery_0_rdf_3_CustomLabel'] =
      dt.title;
  bodyParam[
          'http_2_www_0_tao_0_lu_1_Ontologies_1_TAODelivery_0_rdf_3_Maxexec'] =
      dt.maxExec ?? '';
  bodyParam[
      'http_2_www_0_tao_0_lu_1_Ontologies_1_TAODelivery_0_rdf_3_PeriodStart'] = dt
          .timeStart ??
      '';
  bodyParam[
      'http_2_www_0_tao_0_lu_1_Ontologies_1_TAODelivery_0_rdf_3_PeriodEnd'] = dt
          .timeEnd ??
      '';
  bodyParam[
      'http_2_www_0_tao_0_lu_1_Ontologies_1_TAODelivery_0_rdf_3_DisplayOrder'] = '';
  bodyParam['classUri'] =
      'http_2_www_0_tao_0_lu_1_Ontologies_1_TAODelivery_0_rdf_3_AssembledDelivery';
  bodyParam['uri'] = dt.uri;
  final uri = Uri.http(baseUrl, '/taoDeliveryRdf/DeliveryMgmt/editDelivery');
  final http.Response response = await http.post(uri,
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Cookie': cookie,
        'Accept': 'text/html, */*; q=0.01'
      },
      body: bodyParam);
  return response;
}
