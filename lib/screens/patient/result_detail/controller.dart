import 'package:html/parser.dart';
import 'package:project/screens/patient/result_detail/api.dart';
import 'package:project/screens/patient/result_detail/data.dart';
import 'package:project/util/function/convert_response.dart';
import 'package:state_notifier/state_notifier.dart';

class ResultDetailController extends StateNotifier<ResultDetailData> {
  ResultDetailController(String id, String classUri)
      : super(ResultDetailData(id: id, classUri: classUri)) {
    init(id: id, classUri: classUri);
  }
  void init({String id, String classUri}) {
    ResultDetailData st = state;
    _startInit(st);
    getResultDetail(id: id ?? st.id, classUri: classUri ?? st.classUri)
        .then((body) {
      if (!checkResponseError(body, st)) {
        _doneInit(st);
        return;
      }
      String htmlString = body;
      final document = parse(htmlString);
      final questions = document.getElementsByClassName('matrix');
      for (int i = 1; i < questions.length; i++) {
        final tbody = questions[i].getElementsByTagName('tbody')[0];
        int point = int.parse(tbody
            .getElementsByTagName('tr')[6]
            .getElementsByClassName('dataResult')[0]
            .text);
        st.points.add(point);
        st.totalPoint += point;
      }
      _doneInit(st);
    });
  }

  void _startInit(ResultDetailData st) {
    st.init = false;
    st.error = '';
    if (mounted) state = st.copy();
  }

  void _doneInit(ResultDetailData st) {
    st.init = true;
    if (mounted) state = st.copy();
  }
}
