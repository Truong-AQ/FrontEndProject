import 'dart:convert';

import 'package:project/resources/types.dart';

class ObjectStudyData extends InfoError {
  ObjectStudyData({this.listUri, this.items = const []}) {
    var l = listUri.length;
    if (l % 2 == 1) l += 1;
    if (items.length != l) {
      items = List.generate(l, (index) => null);
    }
  }
  List<String> listUri;
  bool init = false;
  List<ObjectStudyItem> items;
  ObjectStudyData copy() {
    final clone = ObjectStudyData(listUri: listUri, items: items);
    clone.init = init;
    clone.setValue(error: error, numOfError: numOfError);
    return clone;
  }
}

class ObjectStudyItem {
  String urlAudio, label, urlImg;
  ObjectStudyItem({this.urlAudio, this.label, this.urlImg});
  @override
  String toString() {
    Map<String, String> res = {};
    res['"label"'] = '"$label"';
    res['"urlAudio"'] = '"$urlAudio"';
    res['"urlImg"'] = '"$urlImg"';
    return res.toString();
  }

  static ObjectStudyItem getFromString(String stringJson) {
    final json = jsonDecode(stringJson);
    return ObjectStudyItem(
        urlAudio: json['urlAudio'],
        urlImg: json['urlImg'],
        label: json['label']);
  }
}
