
import 'package:permission_handler/permission_handler.dart';

class PermissionClient {
  const PermissionClient();

  /// Request a specific permission if not already granted.
  Future<PermissionStatus> requestPermission(Permission permission) async {
    final status = await permission.status;
    if (!status.isGranted) {
      await permission.request();
    }
    return permission.status;
  }
}
