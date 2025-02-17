import 'dart:developer';

import 'package:hive_ce_flutter/hive_flutter.dart';

class QuestionBoxClient {
  final Box<String> _questionBox;

  QuestionBoxClient({required Box<String> questionBox})
      : _questionBox = questionBox;

  // Fetch all questions from the box.
  List<String> fetchAll() {
    return _questionBox.values.toList();
  }

  // Add a new question to the box. Returns the index of the added question.
  Future<int> addOne(String question) async {
    if (_questionBox.values.contains(question)) {
      return -1;
    } else {
      return await _questionBox.add(question);
    }
  }

  // Edit an existing question at the given index.
  Future<void> editOne(int index, String newQuestion) async {
    await _questionBox.putAt(index, newQuestion);
  }

  // Delete a question at the given index.
  Future<void> deleteOne(int index) async {
    await _questionBox.deleteAt(index);
  }

  // Reorder questions by clearing the box and reinserting them in the new order.
  Future<void> reOrder(List<String> newOrder) async {
    log('Before Refresh happened  ${_questionBox.values}');
    await _questionBox.clear();
    for (var question in newOrder) {
      await _questionBox.add(question);
    }
    log('Refresh happened  ${_questionBox.values}');
  }
}
