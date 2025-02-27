import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart' show HiveX;
import 'package:my_transcriber/app/app.dart';
import 'package:my_transcriber/bootstrap/bootstrap.dart';
import 'package:my_transcriber/chats/chats.dart';
import 'package:my_transcriber/permissions/permissions.dart';

import 'package:my_transcriber/questions/questions.dart';
import 'package:my_transcriber/results/results.dart';

void main() {
  bootstrap(() async {
    final permissionClient = PermissionClient();
    
    await permissionClient.init();
    

    await Hive.initFlutter();
    if (Hive.isBoxOpen('__user_questions__')) {
      Hive.close();
    }

    final userQuestionBox = await Hive.openBox<String>('__user_questions__');
    final questionsBoxClient = QuestionsBoxClient(questionBox: userQuestionBox);
    final questionsRepository = QuestionsRepository(
      questionBoxClient: questionsBoxClient,
    );
    final chatService = ChatService();
    final chatRepository = ChatRepository(chatService: chatService);
    
    final exportService = ExportService();
    final resultsRepository = ResultsRepository(exportService: exportService);
    return App(
      resultsRepository: resultsRepository,
      chatRepository: chatRepository,
      questionsRepository: questionsRepository,
    );
  });
}
