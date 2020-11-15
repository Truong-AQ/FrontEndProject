import 'package:html/parser.dart';
import 'package:project/screens/result_detail/api.dart';
import 'package:project/screens/result_detail/data.dart';
import 'package:state_notifier/state_notifier.dart';

class ResultDetailController extends StateNotifier<ResultDetailData> {
  ResultDetailController(String id, String classUri)
      : super(ResultDetailData(id: id, classUri: classUri)) {
    getResultDetail(id: id, classUri: classUri).then((value) {
      String htmlString = value.body;
      final document = parse(htmlString);
      final questions = document.getElementsByClassName('matrix');
      for (int i = 1; i < questions.length; i++) {
        final tbody = questions[i].getElementsByTagName('tbody')[0];
        state.points.add(int.parse(tbody
            .getElementsByTagName('tr')[6]
            .getElementsByClassName('dataResult')[0]
            .text));
      }
      state.init = true;
      state = state.copy();
    });
  }
}
