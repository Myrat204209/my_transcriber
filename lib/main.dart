import 'package:my_transcriber/app/app.dart';
import 'package:my_transcriber/bootstrap/bootstrap.dart';

import 'package:hive_ce_flutter/hive_flutter.dart' show Hive, HiveX;
import 'package:my_transcriber/chats/chats.dart';
import 'package:my_transcriber/permissions/permissions.dart';

import 'package:my_transcriber/questions/questions.dart';

void main() {
  bootstrap(() async {
    PermissionClient().init();
    // StorageRepository(permissionClient: permissionClient).init();

    await Hive.initFlutter();
    if (Hive.isBoxOpen('__user_questions__')) {
      Hive.close();
      // Hive.deleteBoxFromDisk('__user_questions__');
    }

    final userQuestionBox = await Hive.openBox<String>('__user_questions__');
    final questionsBoxClient = QuestionBoxClient(questionBox: userQuestionBox);
    final questionsRepository = QuestionsRepository(
      questionBoxClient: questionsBoxClient,
    );
    final chatService = ChatService();
    final chatRepository = ChatRepository(chatService: chatService);
    return App(
      // storageRepository: storageRepository,
      chatRepository: chatRepository,
      questionsRepository: questionsRepository,
    );
  });
}
