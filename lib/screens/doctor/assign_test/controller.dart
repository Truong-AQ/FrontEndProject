import 'package:project/util/function/convert_response.dart';
import 'package:state_notifier/state_notifier.dart';
import 'data.dart';
import 'api.dart' as api;

class AssignTestController extends StateNotifier<AssignTestData> {
  AssignTestController() : super(AssignTestData());

  Future<void> initTest() async {
    AssignTestData st = state;
    _initProcess(st);
    await getAssignTest(st.items);
    _doneInit(st);
  }

  Future<bool> getAssignTest(List items, {String classUri}) async {
    items.clear();
    AssignTestData st = state;
    final json = await api.getAssignTest(classUri: classUri);
    if (!checkResponseError(json, st)) return false;
    var children = json['tree'];
    if (children is Map) children = children['children'];
    for (var child in children) {
      items.add(AssignTestItem(
          type: child['type'],
          data: child['data'],
          id: child['attributes']['id'],
          dataUri: child['attributes']['data-uri']));
    }
    return true;
  }

  Future<bool> getChecker(AssignTestItem item) async {
    AssignTestData st = state;
    if (item.checker != null) return true;
    final res = await api.getChecker(id: item.id, groupUri: item.dataUri);
    if (!checkResponseError(res, st))
      return false;
    else
      item.checker = res;
    return true;
  }

  void _initProcess(AssignTestData st) {
    st.error = '';
    st.init = false;
    if (mounted) state = st.copy();
  }

  void _doneInit(AssignTestData st) {
    st.init = true;
    if (mounted) state = st.copy();
  }
}
