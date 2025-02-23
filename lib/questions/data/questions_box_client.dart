import 'package:hive_ce_flutter/hive_flutter.dart' show Box;
import 'package:my_transcriber/questions/questions.dart';

class QuestionsBoxClient {
  final Box<String> _questionBox;

  QuestionsBoxClient({required Box<String> questionBox})
    : _questionBox = questionBox;

  List<String> fetchAll() => [..._questionBox.values];

  Future<int> addOne(String question) async {
    if (question.isEmpty) throw ArgumentError('Question cannot be empty');
    if (_questionBox.values.contains(question)) return -1;
    final key = await _questionBox.add(question);
    return key;
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
    await Future.delayed(Duration.zero);

    final updatedBox = [..._questionBox.values];

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final String item = updatedBox.removeAt(oldIndex);
    updatedBox.insert(newIndex, item);
    await Future.microtask(() async {
      await _questionBox.clear();
      await _questionBox.addAll(updatedBox);
      await _questionBox.flush();
      talker.debug('Persisted: ${_questionBox.values}');
      return;
    });
  }

  void _validateIndex(int index) {
    if (index < 0 || index >= _questionBox.length) {
      throw RangeError.range(
        index,
        0,
        _questionBox.length - 1,
        'index',
        'Invalid index Custom Log Exception',
      );
    }
  }
}
