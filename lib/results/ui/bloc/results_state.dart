part of 'results_bloc.dart';

enum ResultsStatus { initial, listing, opening, deleting,success, failure }

final class ResultsState extends Equatable {
  final ResultsStatus status;
  final List<FileSystemEntity> chats;
  const ResultsState({required this.status, this.chats = const []});
  const ResultsState.initial() : this(status: ResultsStatus.initial);

  ResultsState copyWith({
    ResultsStatus? status,
    List<FileSystemEntity>? chats,
  }) {
    return ResultsState(
      status: status ?? this.status,
      chats: chats ?? this.chats,
    );
  }

  @override
  List<Object> get props => [status, chats];
}
