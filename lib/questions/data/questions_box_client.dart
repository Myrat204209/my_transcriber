import 'package:hive_ce/hive.dart' show Box;

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
    if (_questionBox.getAt(index) == newQuestion.trim()) return;
    await _questionBox.putAt(index, newQuestion.trim());
  }

  Future<void> deleteOne(int index) async {
    _validateIndex(index);
    await _questionBox.deleteAt(index);
  }

  Future<void> reOrder({required List<String> reorderedList}) async {
    await _questionBox.clear();
    await _questionBox.addAll(reorderedList);
    await _questionBox.flush();
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
