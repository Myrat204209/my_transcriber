part of 'results_bloc.dart';

sealed class ResultsEvent extends Equatable {
  const ResultsEvent();

  @override
  List<Object> get props => [];
}

final class ResultsInitialized extends ResultsEvent {}

final class ResultsListed extends ResultsEvent {}

final class ResultsOpenRequested extends ResultsEvent {
  final FileSystemEntity file;

  const ResultsOpenRequested({required this.file});
}

final class ResultsDeleteRequested extends ResultsEvent {
  final FileSystemEntity file;

  const ResultsDeleteRequested({required this.file});
}
