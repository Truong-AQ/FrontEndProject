import 'package:project/screens/doctor/group/api.dart' as api;
import 'package:project/screens/doctor/group/data.dart';
import 'package:project/util/function/convert_response.dart';
import 'package:state_notifier/state_notifier.dart';

class GroupController extends StateNotifier<GroupData> {
  GroupController() : super(GroupData());

  Future<void> initGroup() async {
    GroupData st = state;
    _initProcess(st);
    await _getGroup(st);
    _doneInit(st);
  }

  Future<void> _getGroup(GroupData st) async {
    final json = await api.getGroup();
    if (!checkResponseError(json, st)) return;
    List children = json['tree']['children'];
    for (var child in children) {
      st.items.add(GroupItem(
          type: child['type'],
          data: child['data'],
          id: child['attributes']['id'],
          dataUri: child['attributes']['data-uri']));
    }
  }

  Future<bool> getChecker(GroupItem item) async {
    GroupData st = state;
    if (item.checker != null) return true;
    final res = await api.getChecker(id: item.id, groupUri: item.dataUri);
    if (!checkResponseError(res, st))
      return false;
    else
      item.checker = res;
    return true;
  }

  void _initProcess(GroupData st) {
    st.error = '';
    st.init = false;
    if (mounted) state = st.copy();
  }

  void _doneInit(GroupData st) {
    st.init = true;
    if (mounted) state = st.copy();
  }
}
