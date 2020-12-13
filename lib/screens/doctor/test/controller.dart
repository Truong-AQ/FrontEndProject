import 'package:project/util/function/convert_response.dart';
import 'package:state_notifier/state_notifier.dart';
import 'data.dart';
import 'api.dart' as api;

class TestController extends StateNotifier<TestData> {
  TestController() : super(TestData());

  Future<void> initTest() async {
    TestData st = state;
    _initProcess(st);
    await getTest(st.items);
    _doneInit(st);
  }

  Future<bool> getTest(List items, {String classUri}) async {
    items.clear();
    TestData st = state;
    final json = await api.getTest(classUri: classUri);
    if (!checkResponseError(json, st)) return false;
    var children = json['tree'];
    if (children is Map) children = children['children'];
    for (var child in children) {
      items.add(TestItem(
          type: child['type'],
          data: child['data'],
          id: child['attributes']['id'],
          dataUri: child['attributes']['data-uri']));
    }
    return true;
  }

  Future<bool> getChecker(TestItem item) async {
    TestData st = state;
    if (item.checker != null) return true;
    final res = await api.getChecker(id: item.id, groupUri: item.dataUri);
    if (!checkResponseError(res, st))
      return false;
    else
      item.checker = res;
    return true;
  }

  void _initProcess(TestData st) {
    st.error = '';
    st.init = false;
    if (mounted) state = st.copy();
  }

  void _doneInit(TestData st) {
    st.init = true;
    if (mounted) state = st.copy();
  }
}
