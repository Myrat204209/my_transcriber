// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_transcriber/chats/chats.dart';
import 'package:my_transcriber/questions/questions.dart';
import 'package:my_transcriber/results/results.dart';

import 'app_view.dart';

class App extends StatelessWidget {
  const App({
    required ChatRepository chatRepository,
    required QuestionsRepository questionsRepository,
    required ResultsRepository resultsRepository,
    super.key,
  }) : _resultsRepository = resultsRepository,
       _chatRepository = chatRepository,
       _questionsRepository = questionsRepository;

  final QuestionsRepository _questionsRepository;
  final ChatRepository _chatRepository;
  final ResultsRepository _resultsRepository;
  @override
  Widget build(BuildContext context) {
    final questionsBloc = QuestionsBloc(
      questionsRepository: _questionsRepository,
    )..add(QuestionsInitialized());
    final chatsBloc = ChatsBloc(chatRepository: _chatRepository);
    final resultsBloc = ResultsBloc(resultsRepository: _resultsRepository)
      ..add(ResultsListed());

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _chatRepository),
        RepositoryProvider.value(value: _questionsRepository),
        RepositoryProvider.value(value: _resultsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: questionsBloc),
          BlocProvider.value(value: chatsBloc),
          BlocProvider.value(value: resultsBloc),
        ],
        child: const AppView(),
      ),
    );
  }
}
