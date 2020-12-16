import 'package:project/screens/doctor/choose_item/data.dart';

Map createModelSaveTestItem(ChooseItem item, int index) {
  Map<String, dynamic> model = {};
  model['href'] = item.uri;
  model['label'] = item.data;
  model['qti-type'] = 'assessmentItemRef';
  model['categories'] = [];
  model['identifier'] = 'item-$index';
  model['index'] = index;
  model['isLinear'] = true;
  Map<String, dynamic> itemSessionControl = {};
  itemSessionControl['qti-type'] = 'itemSessionControl';
  itemSessionControl['maxAttempts'] = 0;
  itemSessionControl['showFeedback'] = false;
  itemSessionControl['allowReview'] = true;
  itemSessionControl['showSolution'] = false;
  itemSessionControl['allowComment'] = false;
  itemSessionControl['validateResponses'] = false;
  itemSessionControl['allowSkipping'] = true;
  model['itemSessionControl'] = itemSessionControl;
  return model;
}
