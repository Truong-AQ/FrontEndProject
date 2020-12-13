import 'package:project/resources/types.dart';

import 'api.dart';
import 'data.dart';
import 'package:state_notifier/state_notifier.dart';

class NewTestController extends StateNotifier<NewTestData> {
  NewTestController() : super(NewTestData());

  void setName(String name) {
    NewTestData st = state;
    st.name = name;
  }

  Future<String> createTest() async {
    NewTestData st = state;
    var res = await addInstance();
    if (res is AppError) return res.description;
    st.uri = res['uri'].replaceAll('\\/', '/');
    st.id = st.uri
        .replaceAll('://', '_2_')
        .replaceAll('.', '_0_')
        .replaceAll('/', '_1_')
        .replaceAll('#', '_3_');
    res = await getToken(st);
    if (res is AppError) return res.description;
    st.token = res;
    res = await updateInfo(st);
    if (res is AppError) return res.description;
    return '';
  }
}
