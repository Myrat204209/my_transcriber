import 'package:get_it/get_it.dart';
import 'package:talker/talker.dart';
import 'package:permission_handler/permission_handler.dart';

final _talker = GetIt.I<Talker>();

class PermissionClient {
  const PermissionClient();

  static const List<Permission> _permissions = [
    Permission.speech,
    Permission.storage,
    Permission.microphone,
    Permission.audio,
  ];
  Future<Map<Permission, PermissionStatus>> init() async {
    try {
      Map<Permission, PermissionStatus> statuses = await _permissions.request();

      return statuses;
    } catch (e, st) {
      _talker.error('Error requesting permissions: ', e, st);
      return {};
    }
  }

  Future<void> askStorage() async {
    if (await Permission.manageExternalStorage.status.isDenied) {
      try {
        await Permission.manageExternalStorage.request();
      } catch (e, st) {
        _talker.error('Error requesting storage permission: ', e, st);
      }
    }
  }

  Future<bool> areAllPermissionsGranted() async {
    final statuses = await Future.wait(_permissions.map((p) => p.status));
    return statuses.every((status) => status.isGranted);
  }
  Future<PermissionStatus> requestPermission(Permission permission) async {
    return await permission.request();
  }
  Future<PermissionStatus> checkPermission(Permission permission) async {
    return await permission.status;
  }
  Future<Map<Permission, PermissionStatus>> requestMissingPermissions() async {
    final missingPermissions = await Future.wait(
      _permissions.map((p) async => await p.status.isDenied ? p : null),
    );

    final permissionsToRequest =
        missingPermissions.whereType<Permission>().toList();

    if (permissionsToRequest.isEmpty) {
      return {};
    }

    return await permissionsToRequest.request();
  }

  Future<bool> openAppSettings() => openAppSettings();
}
