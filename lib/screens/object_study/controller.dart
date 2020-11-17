import 'dart:convert';

import 'package:state_notifier/state_notifier.dart';

import 'api.dart';
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
    for (var uri in state.listUri) {
      state.items.add(await getOneObject(uri));
    }
  }

  Future<ObjectStudyItem> getOneObject(String uri) async {
    String htmlFindLink = (await getLink(uri: uri)).body;
    String link = htmlFindLink
        .substring(
            htmlFindLink.indexOf('previewUrl: "') + 'previewUrl: "'.length)
        .replaceAll(RegExp(r'",(.|\s)*'), '');
    String htmlInfo = (await getInfoObjectItem(link: link)).body;
    String jsonInfo = jsonDecode(htmlInfo.substring(
        htmlInfo.indexOf('itemData: ') + 'itemData: '.length,
        htmlInfo.indexOf(RegExp(r'",\s*variableElements'))));
  }
}
