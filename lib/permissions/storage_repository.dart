import 'dart:async';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:my_transcriber/permissions/permissions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart'; // For accessing the file system

sealed class StorageFailure with EquatableMixin implements Exception {
  const StorageFailure(this.error);

  final Object error;

  @override
  List<Object> get props => [error];
}

final class WriteToStorageFailure extends StorageFailure {
  const WriteToStorageFailure(super.error);
}

final class ReadFromStorageFailure extends StorageFailure {
  const ReadFromStorageFailure(super.error);
}

class StorageRepository {
  StorageRepository({
    required PermissionClient permissionClient,
  }) : _permissionClient = permissionClient;

  final PermissionClient _permissionClient;
  Future<void> init() async => await requestPermission();

  Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      if (await _isAndroid10OrAbove()) {
        final status = await _permissionClient
            .requestPermission(Permission.manageExternalStorage);
        if (!status.isGranted) {
          throw Exception(
            'Storage permission (MANAGE_EXTERNAL_STORAGE) denied',
          );
        }
      } else {
        final status =
            await _permissionClient.requestPermission(Permission.storage);
        if (!status.isGranted) {
          throw Exception('Storage permission denied');
        }
      }
    }
  }

  /// Write data to the external storage (file).
  Future<void> writeToStorage(String filename, String content) async {
    try {
      // Request permission to access the storage.
      await requestPermission();

      // Get the directory for storing the file.
      final directory = await _getStorageDirectory();
      final file = File('${directory.path}/$filename');

      // Write content to the file.
      await file.writeAsString(content);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(WriteToStorageFailure(error), stackTrace);
    }
  }

  /// Read data from the external storage (file).
  Future<String> readFromStorage(String filename) async {
    try {
      // Request permission to access the storage.
      await requestPermission();

      // Get the directory for accessing the file.
      final directory = await _getStorageDirectory();
      final file = File('${directory.path}/$filename');

      // Read the content of the file.
      if (file.existsSync()) {
        return await file.readAsString();
      } else {
        throw FileNotFoundException('File not found');
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ReadFromStorageFailure(error), stackTrace);
    }
  }

  /// Request access to storage permissions (for Android < 10),
  /// if access hasn't been previously granted.
  Future<PermissionStatus> requestFromSettings(Permission permission) async {
    final storageStatus = await permission.request();
    if (storageStatus.isDenied || storageStatus.isPermanentlyDenied) {
      await openAppSettings();
    }
    return storageStatus;
  }

  /// Get the directory where files are stored on external storage.
  Future<Directory> _getStorageDirectory() async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      throw DirectoryNotFoundException(
        'Unable to access external storage directory',
      );
    }
    return directory;
  }

  /// Check if the Android version is 10 or above.
  Future<bool> _isAndroid10OrAbove() async {
    if (Platform.isAndroid) {
      final version = int.parse(
        Platform.operatingSystemVersion.split(' ')[0].split('.').first,
      );
      return version >= 10;
    }
    return false;
  }
}

/// Custom Exception: File Not Found
class FileNotFoundException implements Exception {
  FileNotFoundException(this.message);
  final String message;
}

/// Custom Exception: Directory Not Found
class DirectoryNotFoundException implements Exception {
  DirectoryNotFoundException(this.message);
  final String message;
}
