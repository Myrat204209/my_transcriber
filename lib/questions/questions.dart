import 'package:get_it/get_it.dart' show GetIt;
import 'package:talker/talker.dart' show Talker;

export 'ui/ui.dart';
export 'repositories/repositories.dart';
export 'data/data.dart';

final Talker talker = GetIt.I<Talker>();
