import 'package:state_notifier/state_notifier.dart';

import 'data.dart';

class ResultTestTimeController extends StateNotifier<ResultTestTimeData> {
  ResultTestTimeController(String dataUri) : super(ResultTestTimeData(dataUri: dataUri)) {

  }
  
}
