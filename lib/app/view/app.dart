// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'app_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // final themeModeBloc = ThemeModeBloc();
    return const AppView();
    // return MultiRepositoryProvider(
    //   providers: [
    //     // RepositoryProvider.value(value: _operationRepository),
    //     // RepositoryProvider.value(value: _employeesRepository),
    //   ],
    //   child: MultiBlocProvider(
    //     providers: [
    //       // BlocProvider.value(value: themeModeBloc),
    //       // BlocProvider.value(value: productCubit),
    //     ],
    //     child: const AppView(),
    //   ),
    // );
  }
}
