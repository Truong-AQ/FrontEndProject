import 'dart:convert';

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
    List<String> list = state.listUri;
    for (int i = 0; i < list.length; i++) {
      String objectStudyItemString = prefs.getString(list[i]);
      if (objectStudyItemString == null) {
        getOneObject(list[i]).then((value) {
          state.items[i] = value;
          prefs.setString(list[i], state.items[i].toString());
          state = state.copy();
        });
      } else {
        state.items[i] = ObjectStudyItem.getFromString(objectStudyItemString);
        state = state.copy();
      }
    }
  }

  Future<ObjectStudyItem> getOneObject(String uri) async {
    String htmlFindLink = (await getLink(uri: uri)).body;
    String link = htmlFindLink
        .substring(
            htmlFindLink.indexOf('previewUrl: "') + 'previewUrl: "'.length)
        .replaceAll(RegExp(r'",(.|\s)*'), '')
        .replaceAll('\\/', '/');
    String htmlInfo = (await getInfoObjectItem(link: link)).body;
    final jsonInfo = jsonDecode(htmlInfo
        .substring(htmlInfo.indexOf('itemData : ') + 'itemData : '.length,
            htmlInfo.indexOf('variableElements'))
        .replaceAll('"apipAccessibility":""},', '"apipAccessibility":""}'));
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
}
