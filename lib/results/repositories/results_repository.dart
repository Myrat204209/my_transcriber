import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:my_transcriber/chats/chats.dart';

abstract class ResultsFailure with EquatableMixin implements Exception {
  const ResultsFailure(this.error);
  final Object error;

  @override
  List<Object> get props => [error];
}

class ResultsInitializeFailure extends ResultsFailure {
  const ResultsInitializeFailure(super.error);
}

class ResultsListingFailure extends ResultsFailure {
  const ResultsListingFailure(super.error);
}

class ResultsOpeningFailure extends ResultsFailure {
  const ResultsOpeningFailure(super.error);
}

class ResultsDeletingFailure extends ResultsFailure {
  const ResultsDeletingFailure(super.error);
}

class ResultsRepository {
  ResultsRepository({required ExportService exportService})
    : _exporter = exportService;

  final ExportService _exporter;

  Future<void> initialize() async {
    try {
      await _exporter.init();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ResultsInitializeFailure(error), stackTrace);
    }
  }

  Future<List<FileSystemEntity>> listChats() async {
    try {
      return await _exporter.listConversationFiles();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ResultsListingFailure(error), stackTrace);
    }
  }

  Future<void> openChatFile({required FileSystemEntity file}) async {
    try {
      await _exporter.openFile(file);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ResultsOpeningFailure(error), stackTrace);
    }
  }

  Future<void> deleteChatFile({required FileSystemEntity file}) async {
    try {
      await _exporter.deleteFile(file);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ResultsDeletingFailure(error), stackTrace);
    }
  }
}
