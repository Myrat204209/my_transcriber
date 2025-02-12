import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_transcriber/app/app.dart';
import 'package:path_provider/path_provider.dart';

typedef AppBuilder = FutureOr<Widget> Function();
Future<void> bootstrap(AppBuilder builder) async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );

    const blocObserver = AppBlocObserver();
    Bloc.observer = blocObserver;

    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorageDirectory.web
          : HydratedStorageDirectory(
              (await getApplicationDocumentsDirectory()).path),
    );
    if (kDebugMode) {
      await HydratedBloc.storage.clear();
    }

    // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(
      await builder(),
    );
  }, (exception, stackTrace) async {
    // await FirebaseCrashlytics.instance.recordError(exception, stackTrace);
    // PlatformDispatcher.instance.onError = (error, stack) {
    //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    //   return true;
    // };

    // FlutterError.onError = (details) {
    //   log(details.exceptionAsString(), stackTrace: details.stack);
    // };
  });
}
