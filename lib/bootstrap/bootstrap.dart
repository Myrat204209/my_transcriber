import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc;
import 'package:get_it/get_it.dart';
import 'package:talker/talker.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';

typedef AppBuilder = FutureOr<Widget> Function();
Future<void> bootstrap(AppBuilder builder) async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      final talker = GetIt.I.registerSingleton<Talker>(Talker());

      Bloc.observer = TalkerBlocObserver(talker: talker);
      runApp(await builder());
    },
    (exception, stackTrace) async {
      final talker = GetIt.I<Talker>();
      talker.error("Unhandled exception", exception, stackTrace);
    },
  );
}
