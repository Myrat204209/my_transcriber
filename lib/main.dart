import 'package:my_transcriber/app/app.dart';
import 'package:my_transcriber/bootstrap/bootstrap.dart';

import 'package:hive_ce_flutter/hive_flutter.dart' show Hive, HiveX;
import 'package:my_transcriber/permissions/permissions.dart';

import 'package:my_transcriber/questions/questions.dart';

void main() {
  bootstrap(() async {
    const permissionClient = PermissionClient();
    StorageRepository(permissionClient: permissionClient).init();

    MicrophoneRepository(permissionClient: permissionClient).init();

    await Hive.initFlutter();

    final userQuestionBox = await Hive.openBox<String>('__user_questions__');
    final questionsBoxClient = QuestionBoxClient(questionBox: userQuestionBox);
    final questionsRepository = QuestionsRepository(
      questionBoxClient: questionsBoxClient,
    );
    return App(
      // storageRepository: storageRepository,
      questionsRepository: questionsRepository,
    );
  });
}
