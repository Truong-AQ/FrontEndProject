import 'package:project/util/common_data_question.dart';

class PairingData extends CommonDataQuestion{
  List<String> questions = [
    'AO',
    'DUA HAU',
    'CAP SACH',
    'DUA VANG',
    'BA LO',
    'QUAN',
    'BONG DA',
    'CAU LONG'
  ];
  List<String> correctAnswer = [
    'AO',
    'QUAN',
    'DUA HAU',
    'DUA VANG',
    'BA LO',
    'CAP SACH',
    'BONG DA',
    'CAU LONG'
  ];
  List<String> answerUser = ['', '', '', '', '', '', '', ''];
  bool isCorrect = false;
  bool isComplete = false;
  int nWordsChoosed = 0;
  PairingData copy() {
    final clone = PairingData();
    clone.questions = questions;
    clone.correctAnswer = correctAnswer;
    clone.answerUser = answerUser;
    clone.isCorrect = isCorrect;
    clone.nWordsChoosed = nWordsChoosed;
    clone.isComplete = isComplete;
    return clone;
  }
}
