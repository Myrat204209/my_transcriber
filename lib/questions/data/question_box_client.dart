import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:my_transcriber/questions/questions.dart';

class QuestionBoxClient {
  final Box<String> _questionBox;

  QuestionBoxClient({required Box<String> questionBox})
    : _questionBox = questionBox;

  List<String> fetchAll() => [..._questionBox.values];

  Future<int> addOne(String question) async {
    if (question.isEmpty) {
      throw ArgumentError('Question cannot be empty');
    }
    return _questionBox.values.contains(question)
        ? -1
        : await _questionBox.add(question);
  }

  Future<void> editOne(int index, String newQuestion) async {
    _validateIndex(index);
    await _questionBox.putAt(index, newQuestion);
  }

  Future<void> deleteOne(int index) async {
    _validateIndex(index);
    await _questionBox.deleteAt(index);
  }

  Future<void> reOrder({required int oldIndex, required int newIndex}) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    logger.d('Before swap: ${_questionBox.values}');
    final item = _questionBox.getAt(oldIndex)!;
    await _questionBox.deleteAt(oldIndex);
    await _questionBox.putAt(newIndex, item);

    logger.i('After swap: ${_questionBox.values}');
  }

  void _validateIndex(int index) {
    if (index < 0 || index >= _questionBox.length) {
      throw RangeError.range(index, 0, _questionBox.length - 1, 'index');
    }
  }
}
