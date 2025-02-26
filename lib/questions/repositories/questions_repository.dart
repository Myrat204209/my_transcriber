import 'package:equatable/equatable.dart';
import 'package:my_transcriber/questions/questions.dart';

abstract class QuestionsFailure with EquatableMixin implements Exception {
  const QuestionsFailure(this.error);

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
  const QuestionsRepository({required QuestionsBoxClient questionBoxClient})
    : _questionBoxClient = questionBoxClient;

  final QuestionsBoxClient _questionBoxClient;

  Future<List<String>> fetchQuestions() async {
    try {
      return _questionBoxClient.fetchAll();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(FetchQuestionsFailure(error), stackTrace);
    }
  }

  Future<int> addQuestion(String question) async {
    try {
      return await _questionBoxClient.addOne(question);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(AddQuestionFailure(error), stackTrace);
    }
  }

  Future<void> editQuestion(int index, String newQuestion) async {
    try {
      await _questionBoxClient.editOne(index, newQuestion);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(EditQuestionFailure(error), stackTrace);
    }
  }

  Future<void> deleteQuestion(int index) async {
    try {
      await _questionBoxClient.deleteOne(index);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(DeleteQuestionFailure(error), stackTrace);
    }
  }

  Future<void> reorderQuestions({required List<String> reorderedList}) async {
    try {
      await _questionBoxClient.reOrder(reorderedList: reorderedList);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ReorderQuestionsFailure(error), stackTrace);
    }
  }
}
