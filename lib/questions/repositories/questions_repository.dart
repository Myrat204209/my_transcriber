import 'package:equatable/equatable.dart';
import '../data/question_box_client.dart';

/// A base failure for the questions repository failures
abstract class QuestionsFailure with EquatableMixin implements Exception {
  const QuestionsFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object> get props => [error];
}

class FetchQuestionsFailure extends QuestionsFailure {
  const FetchQuestionsFailure(super.error);
}

class AddQuestionFailure extends QuestionsFailure {
  const AddQuestionFailure(super.error);
}

class EditQuestionFailure extends QuestionsFailure {
  const EditQuestionFailure(super.error);
}

class DeleteQuestionFailure extends QuestionsFailure {
  const DeleteQuestionFailure(super.error);
}

class ReorderQuestionsFailure extends QuestionsFailure {
  const ReorderQuestionsFailure(super.error);
}

class QuestionsRepository {
  const QuestionsRepository({
    required QuestionBoxClient questionBoxClient,
  }) : _questionBoxClient = questionBoxClient;

  final QuestionBoxClient _questionBoxClient;

  /// Method to fetch all questions
  Future<List<String>> fetchQuestions() async {
    try {
      return _questionBoxClient.fetchAll();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(FetchQuestionsFailure(error), stackTrace);
    }
  }

  /// Method to add a new question
  Future<int> addQuestion(String question) async {
    try {
      return await _questionBoxClient.addOne(question);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(AddQuestionFailure(error), stackTrace);
    }
  }

  /// Method to edit an existing question
  Future<void> editQuestion(int index, String newQuestion) async {
    try {
      await _questionBoxClient.editOne(index, newQuestion);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(EditQuestionFailure(error), stackTrace);
    }
  }

  /// Method to delete a question
  Future<void> deleteQuestion(int index) async {
    try {
      await _questionBoxClient.deleteOne(index);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(DeleteQuestionFailure(error), stackTrace);
    }
  }

  /// Method to reorder questions
  Future<void> reorderQuestions(List<String> newOrder) async {
    try {
      await _questionBoxClient.reOrder(newOrder);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ReorderQuestionsFailure(error), stackTrace);
    }
  }
}
