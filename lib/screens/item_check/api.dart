import 'package:http/http.dart' as http;
import 'package:project/resources/strings.dart';
import 'package:project/resources/types.dart';
import 'package:project/util/function/convert_response.dart';
import 'package:project/util/variable.dart';

Future<dynamic> getData({TypeItemChecker type, String classUri}) async {
  try {
    http.Response response = await _getData(type: type, classUri: classUri);
    return convertResponse7(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> saveData(
    {TypeItemChecker type, List instances, String resourceUri}) async {
  try {
    http.Response response = await _saveData(
        type: type, instances: instances, resourceUri: resourceUri);
    return convertResponse1(response);
  } on Exception catch (e) {
    return convertResponseException(e);
  }
}

Future<dynamic> _saveData(
    {TypeItemChecker type, List instances, String resourceUri}) async {
  final uri = Uri.http(
      baseUrl,
      type == TypeItemChecker.TEST || type == TypeItemChecker.GROUP
          ? '/tao/GenerisTree/setValues'
          : '/tao/GenerisTree/setReverseValues');
  final http.Response response = await http.post(uri, headers: {
    'X-Requested-With': 'XMLHttpRequest',
    'Cookie': cookie
  }, body: {
    'instances': instances.map((e) => '"$e"').toList().toString(),
    'resourceUri': resourceUri,
    'propertyUri': type == TypeItemChecker.TEST
        ? 'http://www.tao.lu/Ontologies/TAOGroup.rdf#Deliveries'
        : (type == TypeItemChecker.TESTGROUP
            ? 'http://www.tao.lu/Ontologies/TAOGroup.rdf#Deliveries'
            : 'http://www.tao.lu/Ontologies/TAOGroup.rdf#member')
  });
  return response;
}

Future<http.Response> _getData({TypeItemChecker type, String classUri}) async {
  final Map<String, String> queryParams = {
    'rootNode': type == TypeItemChecker.TESTTAKER
        ? 'http://www.tao.lu/Ontologies/TAOSubject.rdf#Subject'
        : (type == TypeItemChecker.GROUP || type == TypeItemChecker.TESTGROUP
            ? 'http://www.tao.lu/Ontologies/TAOGroup.rdf#Group'
            : 'http://www.tao.lu/Ontologies/TAODelivery.rdf#AssembledDelivery'),
  };
  if (classUri != null) queryParams['classUri'] = classUri;
  final uri = Uri.http(baseUrl, '/tao/GenerisTree/getData', queryParams);
  final http.Response response = await http.post(uri,
      headers: {'X-Requested-With': 'XMLHttpRequest', 'Cookie': cookie});
  return response;
}
