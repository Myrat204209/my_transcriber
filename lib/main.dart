import 'package:my_transcriber/app/app.dart';
import 'package:my_transcriber/bootstrap/bootstrap.dart';

import 'package:hive_ce_flutter/hive_flutter.dart' show Hive, HiveX;

void main() {
  bootstrap(() async {
    // const permissionClient = PermissionClient();
    // await permissionClient.init();

    await Hive.initFlutter();
    // Hive.registerAdapters();

    // final userReportsBox =
    //     await Hive.openBox<List<dynamic>>(HiveBoxKeys.userReportsBoxKey);

    return App();
  });
}
