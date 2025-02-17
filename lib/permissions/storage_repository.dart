import 'dart:async';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:my_transcriber/permissions/permissions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:logger/logger.dart';

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
  final Logger _logger = Logger();

  bool _permissionGranted = false;
  Future<void>? _permissionRequestFuture;

  Future<void> init() async => await requestPermission();

  Future<void> requestPermission() async {
    if (_permissionGranted) return;

    // Если уже запущен запрос, ждем его завершения.
    if (_permissionRequestFuture != null) {
      await _permissionRequestFuture;
      return;
    }

    _permissionRequestFuture = _doRequestPermission();

    try {
      await _permissionRequestFuture;
    } finally {
      _permissionRequestFuture = null;
    }
  }

  Future<void> _doRequestPermission() async {
    if (Platform.isAndroid) {
      bool granted = false;
      if (await _isAndroid10OrAbove()) {
        final status = await _permissionClient
            .requestPermission(Permission.manageExternalStorage);
        granted = status.isGranted;
        if (!granted) {
          throw Exception(
            'Storage permission (MANAGE_EXTERNAL_STORAGE) denied',
          );
        }
      } else {
        final status =
            await _permissionClient.requestPermission(Permission.storage);
        granted = status.isGranted;
        if (!granted) {
          throw Exception('Storage permission denied');
        }
      }
      _permissionGranted = granted;
    }
  }

  /// Запись данных во внешнее хранилище (файл).
  Future<void> writeToStorage(String filename, String content) async {
    try {
      await requestPermission();

      final directory = await _getStorageDirectory();
      final filePath = path.join(directory.path, filename);
      final file = File(filePath);

      await file.writeAsString(content);
    } catch (error, stackTrace) {
      _logger.e("Write to storage error", error: error, stackTrace: stackTrace);
      Error.throwWithStackTrace(WriteToStorageFailure(error), stackTrace);
    }
  }

  /// Чтение данных из внешнего хранилища (файл).
  Future<String> readFromStorage(String filename) async {
    try {
      await requestPermission();

      final directory = await _getStorageDirectory();
      final filePath = path.join(directory.path, filename);
      final file = File(filePath);

      if (await file.exists()) {
        return await file.readAsString();
      } else {
        throw FileNotFoundException('File not found: $filePath');
      }
    } catch (error, stackTrace) {
      _logger.e("Read from storage error",
          error: error, stackTrace: stackTrace);
      Error.throwWithStackTrace(ReadFromStorageFailure(error), stackTrace);
    }
  }

  /// Запрос разрешения через настройки (если необходимо).
  Future<PermissionStatus> requestFromSettings(Permission permission) async {
    var storageStatus = await permission.request();
    if (storageStatus.isDenied || storageStatus.isPermanentlyDenied) {
      await openAppSettings();
      // Повторная проверка после возврата из настроек.
      storageStatus = await permission.request();
    }
    return storageStatus;
  }

  /// Получение директории для хранения файлов.
  Future<Directory> _getStorageDirectory() async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      throw DirectoryNotFoundException(
        'Unable to access external storage directory',
      );
    }
    return directory;
  }

  Future<bool> _isAndroid10OrAbove() async {
  if (Platform.isAndroid) {
    try {
      final osVersion = Platform.operatingSystemVersion;
      // Ищем первую последовательность цифр в строке
      final regExp = RegExp(r'(\d+)');
      final match = regExp.firstMatch(osVersion);
      if (match != null) {
        final versionStr = match.group(1);
        final version = int.tryParse(versionStr ?? '');
        if (version != null) {
          return version >= 10;
        }
      }
      _logger.w("Unable to parse Android version from: $osVersion");
      return false;
    } catch (e) {
      _logger.w("Failed to parse Android version", error:  e);
      return false;
    }
  }
  return false;
}

}

/// Кастомное исключение: Файл не найден.
class FileNotFoundException implements Exception {
  FileNotFoundException(this.message);
  final String message;

  @override
  String toString() => 'FileNotFoundException: $message';
}

/// Кастомное исключение: Директория не найдена.
class DirectoryNotFoundException implements Exception {
  DirectoryNotFoundException(this.message);
  final String message;

  @override
  String toString() => 'DirectoryNotFoundException: $message';
}
