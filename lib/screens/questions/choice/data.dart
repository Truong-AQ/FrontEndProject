class ChoiceData {
  ChoiceData(this.data) {
    label = data['label'];
    audio = data['audio'];
    urlImg = data['img'];
  }
  Map<String, dynamic> data;
  String label;
  String audio;
  List<String> answer, urlImg;
  ChoiceData copy() {
    ChoiceData clone = ChoiceData(data);
    clone.label = label;
    clone.audio = audio;
    clone.urlImg = urlImg;
    return clone;
  }
}
