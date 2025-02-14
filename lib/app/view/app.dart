// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_transcriber/questions/questions.dart';

import 'app_view.dart';

class App extends StatelessWidget {
  const App(
      {
        // required StorageRepository storageRepository,
      required QuestionsRepository questionsRepository,
      super.key})
      :
      //  _storageRepository = storageRepository,
        _questionsRepository = questionsRepository;
  // final StorageRepository _storageRepository;

  final QuestionsRepository _questionsRepository;

  @override
  Widget build(BuildContext context) {
    // final themeModeBloc = ThemeModeBloc();
    final questionsBloc =
        QuestionsBloc(questionsRepository: _questionsRepository)
          ..add(QuestionsRequested());

    return MultiRepositoryProvider(
      providers: [
        // RepositoryProvider.value(value: _storageRepository),
        RepositoryProvider.value(value: _questionsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: questionsBloc),
          // BlocProvider.value(value: productCubit),
        ],
        child: const AppView(),
      ),
    );
  }
}
