import 'package:project/screens/test/data.dart';

Map<String, dynamic> convertListAnswer(
    {List<AnswerChoice> answer, TypeQuestion typeQuestion}) {
  switch (typeQuestion) {
    case TypeQuestion.ASSIGNING:
      Map<String, dynamic> item = {};
      item['"identifier"'] = answer.map((e) => '"${e.id}"').toList();
      return item;
    case TypeQuestion.SORT:
      Map<String, dynamic> item = {};
      for (int i = 0; i < answer.length; i++) {
        if (answer[i] == null) {
          answer.removeAt(i);
          i--;
        }
      }
      item['"identifier"'] = answer.map((e) => '"${e.id}"').toList();
      return item;
      break;
    case TypeQuestion.PAIRING:
      Map<String, dynamic> item = {};
      item['"pair"'] = [];
      for (int i = 0; i < answer.length; i += 2) {
        if (answer[i] == null || answer[i + 1] == null) break;
        List<AnswerChoice> tmp = [];
        tmp.add(answer[i]);
        tmp.add(answer[i + 1]);
        (item['"pair"'] as List).add(tmp.map((e) => '"${e.id}"').toList());
      }
      return item;
      break;
  }
  return null;
}
