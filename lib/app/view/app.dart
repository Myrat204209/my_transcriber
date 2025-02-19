// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_transcriber/chats/chats.dart';
import 'package:my_transcriber/questions/questions.dart';

import 'app_view.dart';

class App extends StatelessWidget {
  const App(
      {
      // required StorageRepository storageRepository,
      required ChatRepository chatRepository,
      required QuestionsRepository questionsRepository,
      super.key})
      :
        //  _storageRepository = storageRepository,
        _chatRepository = chatRepository,
        _questionsRepository = questionsRepository;
  // final StorageRepository _storageRepository;

  final QuestionsRepository _questionsRepository;
  final ChatRepository _chatRepository;
  @override
  Widget build(BuildContext context) {
    // final themeModeBloc = ThemeModeBloc();
    final questionsBloc =
        QuestionsBloc(questionsRepository: _questionsRepository)
          ..add(QuestionsInitialized());
    final chatsBloc = ChatsBloc(chatRepository: _chatRepository);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _chatRepository,),
        // RepositoryProvider.value(value: _storageRepository),
        RepositoryProvider.value(value: _questionsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: questionsBloc),
          BlocProvider.value(value: chatsBloc)
          // BlocProvider.value(value: productCubit),
        ],
        child: const AppView(),
      ),
    );
  }
}
