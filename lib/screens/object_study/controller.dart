import 'package:async/async.dart';
import 'package:project/util/function/convert_response.dart';
import 'package:project/util/variable.dart';
import 'package:state_notifier/state_notifier.dart';

import 'api.dart';
import 'data.dart';

class ObjectStudyController extends StateNotifier<ObjectStudyData> {
  ObjectStudyController({List<String> listUri})
      : super(ObjectStudyData(listUri: listUri));
  Future<void> initObjectStudy() async {
    await getObjectStudy();
  }

  Future<void> getObjectStudy() async {
    ObjectStudyData st = state;
    _startInit(st);
    List<String> list = st.listUri;

    List<CancelableOperation> listRequests = [];
    for (int i = 0; i < list.length; i++) {
      String objectStudyItemString = prefs.getString(list[i]);
      if (objectStudyItemString == null) {
        listRequests
            .add(CancelableOperation.fromFuture(getOneObject(list[i], st)));
      } else {
        listRequests.add(null);
        st.items[i] = ObjectStudyItem.getFromString(objectStudyItemString);
        if (mounted) state = st.copy();
      }
    }

    if (listRequests[0] != null)
      listRequests[0].value.then((value) {
        if (value != null) _saveLocal(st, list, 0, value);
        _doneInit(st);
      });
    else
      _doneInit(st);

    for (int i = 1; i < listRequests.length; i++) {
      if (st.error != '') {
        listRequests.forEach((request) => request.cancel());
        break;
      }
      if (listRequests[i] != null) {
        listRequests[i].value.then((value) {
          if (value != null) _saveLocal(st, list, i, value);
        });
      }
    }
  }

  Future<ObjectStudyItem> getOneObject(String uri, ObjectStudyData st) async {
    final link = await getLink(uri: uri);
    if (!checkResponseError(link, st)) return null;

    final jsonInfo = await getInfoObjectItem(link: link);
    if (!checkResponseError(jsonInfo, st)) return null;

    Map<String, dynamic> elements = jsonInfo['body']['elements'];
    ObjectStudyItem objectStudyItem = ObjectStudyItem();
    String baseLink = link.replaceAll('index', '');
    for (var valElement in elements.values) {
      final img = valElement['attributes']['src'];
      if (img != null) {
        objectStudyItem.urlImg = '$baseLink${img.replaceAll('\\/', '/')}';
      } else {
        objectStudyItem.urlAudio =
            '$baseLink${valElement['object']['attributes']['data'].replaceAll('\\/', '/')}';
      }
    }
    objectStudyItem.label = jsonInfo['attributes']['label'];
    return objectStudyItem;
  }

  void _saveLocal(ObjectStudyData st, List<String> list, int posInList,
      ObjectStudyItem item) {
    st.items[posInList] = item;
    prefs.setString(list[posInList], st.items[posInList].toString());
    if (mounted) state = st.copy();
  }

  void _startInit(ObjectStudyData st) {
    st.error = '';
    st.init = false;
    if (mounted) state = st.copy();
  }

  void _doneInit(ObjectStudyData st) {
    st.init = true;
    if (mounted) state = st.copy();
  }
}
