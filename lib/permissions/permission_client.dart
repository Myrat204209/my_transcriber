import 'package:get_it/get_it.dart';
import 'package:talker/talker.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionClient {
  const PermissionClient();

  /// List of permissions required by the app.
  static const List<Permission> _permissions = [
    Permission.speech,
    Permission.storage,
    Permission.microphone,
    // Permission.manageExternalStorage,
    Permission.audio,
  ];

  /// Initializes and requests all required permissions.
  ///
  /// Returns a [Map] with the status of each permission.
  Future<Map<Permission, PermissionStatus>> init() async {
    try {
      Map<Permission, PermissionStatus> statuses = await _permissions.request();

      // if (await Permission.manageExternalStorage.status.isDenied) {
      //   statuses[Permission.manageExternalStorage] =
      //       await Permission.manageExternalStorage.request();
      // }

      return statuses;
    } catch (e,st) {
      GetIt.I<Talker>().error('Error requesting permissions: ',e,st);
      return {};
    }
  }

  /// Checks if all required permissions are granted.
  ///
  /// Returns `true` if all permissions are granted, `false` otherwise.
  Future<bool> areAllPermissionsGranted() async {
    final statuses = await Future.wait(_permissions.map((p) => p.status));
    return statuses.every((status) => status.isGranted);
  }

  /// Requests a specific permission.
  ///
  /// Returns the [PermissionStatus] of the requested permission.
  Future<PermissionStatus> requestPermission(Permission permission) async {
    return await permission.request();
  }

  /// Checks the status of a specific permission.
  ///
  /// Returns the [PermissionStatus] of the requested permission.
  Future<PermissionStatus> checkPermission(Permission permission) async {
    return await permission.status;
  }

  /// Requests permissions that are not granted.
  ///
  /// Returns a [Map] with the status of each requested permission.
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
