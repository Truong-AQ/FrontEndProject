
import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class ObjectStudyController extends StateNotifier<ObjectStudyData> {
  ObjectStudyController({List<String> listUri})
      : super(ObjectStudyData(listUri: listUri));
  Future<void> initObjectStudy() async {
    state.process = true;
    state = state.copy();
    await getObjectStudy();
    state.process = false;
    state = state.copy();
  }

  Future<void> getObjectStudy({String classUri}) async {
    
  }
  Future<ObjectStudyItem> getOneObject(String uri) {
// String s = '''"http:\/\/aigle.blife.ai\/tao\/ServiceModule\/getUserPropertyValues",
//                 ''';
//   s = s.replaceAll(RegExp(r',\s*'), '');
//   print(s);
  }
}
