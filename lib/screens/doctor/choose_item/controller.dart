import 'dart:convert';

import 'package:project/resources/types.dart';
import 'package:project/util/function/add_quotes.dart';
import 'package:project/util/function/convert_response.dart';
import 'package:project/util/function/create_model_test.dart';
import 'package:state_notifier/state_notifier.dart';
import 'data.dart';
import 'api.dart' as api;

class ChooseItemController extends StateNotifier<ChooseItemData> {
  ChooseItemController({String uri}) : super(ChooseItemData(uri: uri));

  Future<void> initTest() async {
    ChooseItemData st = state;
    _initProcess(st);
    await getItems(st.items);
    _doneInit(st);
  }

  Future<bool> getItems(List items, {String classUri}) async {
    items.clear();
    ChooseItemData st = state;
    final json = await api.getItems(classUri: classUri);
    if (!checkResponseError(json, st)) return false;
    if (json['data'] == null) return true;
    var children = json['data'][0]['children'];
    for (var child in children) {
      if (!(child['state'] == false && child['type'] == 'class'))
        items.add(ChooseItem(
            type: child['type'], data: child['label'], uri: child['uri']));
    }
    return true;
  }

  void addOrRemoveCheck(ChooseItem item) {
    ChooseItemData st = state;
    if (st.checker.contains(item)) {
      st.checker.remove(item);
      item.isCheck = false;
    } else {
      st.checker.add(item);
      item.isCheck = true;
    }
  }

  Future<String> saveQuestions() async {
    ChooseItemData st = state;
    var res = await api.getTest(uri: st.uri);
    if (res is AppError) return res.description;
    List sectionParts = [];
    for (int i = 0; i < st.checker.length; i++) {
      sectionParts.add(createModelSaveTestItem(st.checker[i], i + 1));
    }
    res = addQuotes(res, {});
    res['"testParts"'][0]['"assessmentSections"'][0]['"sectionParts"'] =
        sectionParts;
    // return res.toString();
    res['"scoring"'] = addQuotes(jsonDecode('''{
    "modes": {
    "none": {
    "key": "none",
    "label": "None",
    "description": "No outcome processing. Erase the existing rules, if any.",
    "qti-type": "none"
    },
    "custom": {
    "key": "custom",
    "label": "Custom",
    "description": "Custom outcome processing. No changes will be made to the existing rules.",
    "qti-type": "custom"
    },
    "total": {
    "key": "total",
    "label": "Tổng điểm",
    "description": "Điểm số sẽ được xử lý cho toàn bộ bài kiểm tra. Tổng của tất cả các kết quả SCORE sẽ được tính toán, kết quả sẽ được thực hiện trong kết quả SCORE_TOTAL. If the category option is set, the score will also be processed per categories, and each results will take place in the SCORE_xxx outcome, where xxx is the name of the category.",
    "qti-type": "total"
    },
    "cut": {
    "key": "cut",
    "label": "Cut score",
    "description": "The score will be processed for the entire test. A sum of all SCORE outcomes will be computed and divided by the sum of MAX SCORE, the result will be compared to the cut score (or pass ratio), then the PASS_TOTAL outcome will be set accordingly. If the category option is set, the score will also be processed per categories, and each results will take place in the PASS_xxx outcome, where xxx is the name of the category.",
    "qti-type": "cut"
    },
    "qti-type": "modes"
    },
    "scoreIdentifier": "SCORE",
    "weightIdentifier": "",
    "cutScore": 0.5,
    "categoryScore": false,
    "outcomeProcessing": "none",
    "qti-type": "scoring"
    }'''), {});
    return res.toString();
    res = await api.saveQuestions(model: res.toString(), dataUri: st.uri);
    if (res is AppError) return res.description;
    return '';
  }

  void _initProcess(ChooseItemData st) {
    st.error = '';
    st.init = false;
    if (mounted) state = st.copy();
  }

  void _doneInit(ChooseItemData st) {
    st.init = true;
    if (mounted) state = st.copy();
  }
}
