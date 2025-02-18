import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:logger/logger.dart' show Logger;

final _logger = GetIt.I<Logger>();

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  // @override
  // void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
  //   if (bloc is ReportsBloc) {
  //     // Only log if the bloc is ReportsBloc
  //     final stopwatch = Stopwatch()..start();
  //     super.onChange(bloc, change);
  //     stopwatch.stop();
  //     log('onChange(${bloc.runtimeType}, $change) took ${stopwatch.elapsedMilliseconds}ms\n');
  //   }
  // }
  @override
  void onEvent(Bloc bloc, Object? event) {
    _logger.t('onEvent(${bloc.runtimeType}, $event) ');
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    _logger.i('onTransition(${bloc.runtimeType}, $transition) ');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _logger.e('onError(${bloc.runtimeType}, $error, $stackTrace)\n');
  }
}
