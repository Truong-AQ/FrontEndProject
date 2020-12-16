import 'package:project/resources/strings.dart';
import 'package:project/resources/types.dart';

import 'data.dart';
import 'api.dart' as api;
import 'package:state_notifier/state_notifier.dart';

class NewAssignTestController extends StateNotifier<NewAssignTestData> {
  NewAssignTestController() : super(NewAssignTestData());

  Future<void> searchTest(List<String> suggestions, String searchText) async {
    NewAssignTestData st = state;
    if (st.isSearch) return;
    st.isSearch = true;
    final res = await api.searchTest(searchText: searchText);
    final items = res['items'];
    for (var item in items) {
      suggestions.add(item['text']);
      st.listUri.add(item['uri']);
    }
    await Future.delayed(Duration(milliseconds: 500));
    if (res is AppError) return;
  }

  Future<String> assignTest(int posNameTestAssign) async {
    if (posNameTestAssign < 0) return nameTestError;
    NewAssignTestData st = state;
    var res =
        await api.addInstance(idNameTestAssign: st.listUri[posNameTestAssign]);
    if (res is AppError) return res.description;
    final idTmp = res['data']['task']['id'].replaceAll('\\/', '/');
    res = await api.getIdAssign(idTmp: idTmp);
    if (res is AppError) return res.description;
    st.id = res['data']['report']['children'][0]['data']['uriResource']
        .replaceAll('\\/', '/');
    st.uri = st.id
        .replaceAll('://', '_2_')
        .replaceAll('.', '_0_')
        .replaceAll('/', '_1_')
        .replaceAll('#', '_3_');
    res = await api.getToken(st);
    if (res is AppError) return res.description;
    st.token = res;
    res = await api.updateInfo(st);
    if (res is AppError) return res.description;
    return '';
  }

  void setTitle(String title) {
    NewAssignTestData st = state;
    st.title = title;
  }

  void setMaxExec(String maxExec) {
    NewAssignTestData st = state;
    st.maxExec = maxExec;
  }

  void setTimeStart(String timeStart) {
    NewAssignTestData st = state;
    st.timeStart = timeStart;
  }

  void setTimeEnd(String timeEnd) {
    NewAssignTestData st = state;
    st.timeEnd = timeEnd;
  }
}
