import 'package:hive_ce_flutter/hive_flutter.dart' show Box;
import 'package:my_transcriber/questions/questions.dart';

class QuestionBoxClient {
  final Box<String> _questionBox;

  QuestionBoxClient({required Box<String> questionBox})
    : _questionBox = questionBox;

  List<String> fetchAll() => [..._questionBox.values];

  Future<int> addOne(String question) async {
    if (question.isEmpty) throw ArgumentError('Question cannot be empty');
    if (_questionBox.values.contains(question)) return -1;
    final key = await _questionBox.add(question);
    await _questionBox.flush();
    return key;
  }

  Future<void> editOne(int index, String newQuestion) async {
    _validateIndex(index);
    await _questionBox.putAt(index, newQuestion);
    await _questionBox.flush();
  }

  Future<void> deleteOne(int index) async {
    _validateIndex(index);
    await _questionBox.deleteAt(index);
    await _questionBox.flush();
  }

  Future<void> reOrder({required int oldIndex, required int newIndex}) async {
    final updatedBox = [..._questionBox.values];
    final item = updatedBox.removeAt(oldIndex);
    if (oldIndex < newIndex) newIndex -= 1;
    updatedBox.insert(newIndex, item);

    await _questionBox.clear();
    await _questionBox.addAll(updatedBox);
    await _questionBox.flush();
    talker.debug('Persisted: ${_questionBox.values}');
  }

  void _validateIndex(int index) {
    if (index < 0 || index >= _questionBox.length) {
      throw RangeError.range(index, 0, _questionBox.length - 1, 'index', 'Invalid index Custom Log Exception');
    }
  }
}
