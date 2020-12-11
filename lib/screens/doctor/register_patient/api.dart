import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';
import 'data.dart';
import 'package:project/util/function/convert_response.dart';

Future<dynamic> addInstance(RegisterPatientData dt) async {
  try {
    http.Response response = await _addInstance(dt);
    return response;
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<http.Response> _addInstance(RegisterPatientData dt) async {
  return await http.post('http://$baseUrl/taoTestTaker/TestTaker/addInstance',
      body: {
        'classUri': 'http_2_www_0_tao_lu_1',
        'id': '',
        'type': 'instance'
      });
}
