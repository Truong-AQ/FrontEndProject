import 'package:project/resources/types.dart';
import 'package:project/screens/item_check/data.dart';
import 'package:project/util/function/convert_response.dart';
import 'package:state_notifier/state_notifier.dart';

import 'api.dart';

class ItemsCheckController extends StateNotifier<ItemsCheckData> {
  ItemsCheckController({TypeItemChecker type, List checker, String resourceUri})
      : super(ItemsCheckData(
            type: type, checker: checker, resourceUri: resourceUri));

  Future<void> initGroup() async {
    ItemsCheckData st = state;
    _initProcess(st);
    await getItem(st.items);
    _doneInit(st);
  }

  Future<bool> getItem(List items, {String classUri}) async {
    ItemsCheckData st = state;
    if (items.length == 0) {
      final json = await getData(type: st.type, classUri: classUri);
      if (!checkResponseError(json, st)) return false;
      List children = json['tree']['children'];
      for (var child in children) {
        final attributes = child['attributes'];
        final id = attributes['id'];
        items.add(CheckItem(
            type: child['type'],
            data: child['data'],
            id: id,
            dataUri: attributes['data-uri'],
            isCheck: st.checker.contains(id)));
      }
    }
    return true;
  }

  void addOrRemoveCheck(String id) {
    ItemsCheckData st = state;
    if (st.checker.contains(id)) {
      st.checker.remove(id);
    } else {
      st.checker.add(id);
    }
  }

  Future<bool> saveItem() async {
    ItemsCheckData st = state;
    final res = await saveData(
        instances: st.checker, resourceUri: st.resourceUri, type: st.type);
    return checkResponseError(res, st);
  }

  void _initProcess(ItemsCheckData st) {
    st.error = '';
    st.init = false;
    if (mounted) state = st.copy();
  }

  void _doneInit(ItemsCheckData st) {
    st.init = true;
    if (mounted) state = st.copy();
  }
}
