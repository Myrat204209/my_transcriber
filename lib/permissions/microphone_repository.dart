import 'package:equatable/equatable.dart';
import 'package:my_transcriber/permissions/permissions.dart';
import 'package:permission_handler/permission_handler.dart';

/// {@template microphone_failure}
/// A base failure for the microphone repository failures.
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
/// A base failure for the speech recognition repository failures.
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

  Future<void> init() async {
    await requestMicrophonePermission();
    await requestSpeechRecognitionPermission();
  }

  Future<void> requestMicrophonePermission() async {
    try {
      final status =
          await _permissionClient.requestPermission(Permission.microphone);
      if (!status.isGranted) {
        throw Exception('Microphone permission denied');
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          RequestMicrophonePermissionFailure(error), stackTrace);
    }
  }

  Future<void> requestSpeechRecognitionPermission() async {
    try {
      final status =
          await _permissionClient.requestPermission(Permission.speech);
      if (!status.isGranted) {
        throw Exception('Speech recognition permission denied');
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          RequestSpeechRecognitionPermissionFailure(error), stackTrace);
    }
  }
}
