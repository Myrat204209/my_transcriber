// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_transcriber/results/results.dart';

part 'results_event.dart';
part 'results_state.dart';

class ResultsBloc extends Bloc<ResultsEvent, ResultsState> {
  ResultsBloc({required ResultsRepository resultsRepository})
    : _resultsRepository = resultsRepository,
      super(ResultsState.initial()) {
    on<ResultsInitialized>(_onInit);
    on<ResultsListed>(_onListed);
    on<ResultsOpenRequested>(_onOpen);
    on<ResultsDeleteRequested>(_onDelete);
  }

  final ResultsRepository _resultsRepository;

  FutureOr<void> _onInit(
    ResultsInitialized event,
    Emitter<ResultsState> emit,
  ) async {
    try {
      await _resultsRepository.initialize();
      add(ResultsListed());
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ResultsStatus.failure));
      addError(error, stackTrace);
    }
  }

  FutureOr<void> _onListed(
    ResultsListed event,
    Emitter<ResultsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ResultsStatus.listing));
      final results = await _resultsRepository.listChats();
      emit(state.copyWith(status: ResultsStatus.success, chats: results));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ResultsStatus.failure));
      addError(error, stackTrace);
    }
  }

  FutureOr<void> _onDelete(
    ResultsDeleteRequested event,
    Emitter<ResultsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ResultsStatus.deleting));
      await _resultsRepository.deleteChatFile(file: event.file);
      add(ResultsListed());
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ResultsStatus.failure));
      addError(error, stackTrace);
    }
  }

  FutureOr<void> _onOpen(
    ResultsOpenRequested event,
    Emitter<ResultsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ResultsStatus.opening));
      await _resultsRepository.openChatFile(file: event.file);
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ResultsStatus.failure));
      addError(error, stackTrace);
    }
  }
}
