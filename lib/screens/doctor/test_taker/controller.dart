import 'package:project/util/function/convert_response.dart';
import 'package:state_notifier/state_notifier.dart';
import 'data.dart';
import 'api.dart' as api;

class TestTakerController extends StateNotifier<TestTakerData> {
  TestTakerController() : super(TestTakerData());

  Future<void> initTestTaker() async {
    TestTakerData st = state;
    _initProcess(st);
    await getTestTaker(st.items);
    _doneInit(st);
  }

  Future<bool> getTestTaker(List items, {String classUri}) async {
    items.clear();
    TestTakerData st = state;
    final json = await api.getTestTaker(classUri: classUri);
    if (!checkResponseError(json, st)) return false;
    var children = json['tree'];
    if (children is Map) children = children['children'];
    for (var child in children) {
      items.add(TesttakerItem(
          type: child['type'],
          data: child['data'],
          id: child['attributes']['id'],
          dataUri: child['attributes']['data-uri']));
    }
    return true;
  }

  Future<bool> getChecker(TesttakerItem item) async {
    TestTakerData st = state;
    if (item.checker != null) return true;
    final res = await api.getChecker(id: item.id, groupUri: item.dataUri);
    if (!checkResponseError(res, st))
      return false;
    else
      item.checker = res;
    return true;
  }

  void _initProcess(TestTakerData st) {
    st.error = '';
    st.init = false;
    if (mounted) state = st.copy();
  }

  void _doneInit(TestTakerData st) {
    st.init = true;
    if (mounted) state = st.copy();
  }
}
