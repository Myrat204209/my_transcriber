import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc;
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:my_transcriber/app/app.dart';

typedef AppBuilder = FutureOr<Widget> Function();
Future<void> bootstrap(AppBuilder builder) async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      // Register Logger singleton
      GetIt.I.registerSingleton<Logger>(Logger());

      // await Firebase.initializeApp(
      //   options: DefaultFirebaseOptions.currentPlatform,
      // );

      const blocObserver = AppBlocObserver();
      Bloc.observer = blocObserver;
      // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      runApp(await builder());
    },
    (exception, stackTrace) async {
      final logger = GetIt.I<Logger>();
      logger.e("Unhandled exception", error: exception, stackTrace: stackTrace);
      // await FirebaseCrashlytics.instance.recordError(exception, stackTrace);
      // PlatformDispatcher.instance.onError = (error, stack) {
      //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      //   return true;
      // };

      // FlutterError.onError = (details) {
      //   log(details.exceptionAsString(), stackTrace: details.stack);
      // };
    },
  );
}
