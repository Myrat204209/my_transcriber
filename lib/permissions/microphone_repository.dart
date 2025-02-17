import 'package:equatable/equatable.dart';
import 'package:my_transcriber/permissions/permissions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';

/// {@template microphone_failure}
/// Базовый класс ошибок для репозитория микрофона.
/// {@endtemplate}
sealed class MicrophoneFailure with EquatableMixin implements Exception {
  const MicrophoneFailure(this.error);
  final Object error;
  @override
  List<Object> get props => [error];
}

final class RequestMicrophonePermissionFailure extends MicrophoneFailure {
  const RequestMicrophonePermissionFailure(super.error);
}

/// {@template speech_recognition_failure}
/// Базовый класс ошибок для репозитория распознавания речи.
/// {@endtemplate}
sealed class SpeechRecognitionFailure with EquatableMixin implements Exception {
  const SpeechRecognitionFailure(this.error);
  final Object error;
  @override
  List<Object> get props => [error];
}

final class RequestSpeechRecognitionPermissionFailure
    extends SpeechRecognitionFailure {
  const RequestSpeechRecognitionPermissionFailure(super.error);
}

class MicrophoneRepository {
  MicrophoneRepository({
    required PermissionClient permissionClient,
  }) : _permissionClient = permissionClient;

  final PermissionClient _permissionClient;
  final Logger _logger = Logger();

  bool _microphonePermissionGranted = false;
  Future<void>? _microphonePermissionRequestFuture;

  bool _speechPermissionGranted = false;
  Future<void>? _speechPermissionRequestFuture;

  Future<void> init() async {
    await requestMicrophonePermission();
    // await requestSpeechRecognitionPermission();
  }

  Future<void> requestMicrophonePermission() async {
    if (_microphonePermissionGranted) return;

    // Если уже запущен запрос — ждем его завершения.
    if (_microphonePermissionRequestFuture != null) {
      await _microphonePermissionRequestFuture;
      return;
    }

    _microphonePermissionRequestFuture = _doRequestMicrophonePermission();
    try {
      await _microphonePermissionRequestFuture;
    } finally {
      _microphonePermissionRequestFuture = null;
    }
  }

  Future<void> _doRequestMicrophonePermission() async {
    try {
      final status =
          await _permissionClient.requestPermission(Permission.microphone);
      if (!status.isGranted) {
        throw Exception('Microphone permission denied');
      }
      _microphonePermissionGranted = true;
    } catch (error, stackTrace) {
      _logger.e("Ошибка запроса разрешения для микрофона",
          error: error, stackTrace: stackTrace);
      Error.throwWithStackTrace(
          RequestMicrophonePermissionFailure(error), stackTrace);
    }
  }

  Future<void> requestSpeechRecognitionPermission() async {
    if (_speechPermissionGranted) return;

    if (_speechPermissionRequestFuture != null) {
      await _speechPermissionRequestFuture;
      return;
    }

    _speechPermissionRequestFuture = _doRequestSpeechRecognitionPermission();
    try {
      await _speechPermissionRequestFuture;
    } finally {
      _speechPermissionRequestFuture = null;
    }
  }

  Future<void> _doRequestSpeechRecognitionPermission() async {
    try {
      final status =
          await _permissionClient.requestPermission(Permission.speech);
      if (!status.isGranted) {
        throw Exception('Speech recognition permission denied');
      }
      _speechPermissionGranted = true;
    } catch (error, stackTrace) {
      _logger.e("Ошибка запроса разрешения для распознавания речи",
          error: error, stackTrace: stackTrace);
      Error.throwWithStackTrace(
          RequestSpeechRecognitionPermissionFailure(error), stackTrace);
    }
  }
}
