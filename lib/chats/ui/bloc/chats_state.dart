part of 'chats_bloc.dart';

enum ChatsStatus {
  initial, 
  started, 
  questioned, 
  beeped, 
  listening, 
  finished, 
  error, 
}

class ChatsState extends Equatable {
  final ChatsStatus status;
  final String? currentQuestion;
  final String? recognizedText;
  final String? errorMessage;
  final bool speechEnabled;

  const ChatsState({
    required this.status,
    this.currentQuestion,
    this.recognizedText,
    this.errorMessage,
    this.speechEnabled = true,
  });

  ChatsState copyWith({
    ChatsStatus? status,
    String? currentQuestion,
    String? recognizedText,
    String? errorMessage,
    bool? speechEnabled,
  }) {
    return ChatsState(
      status: status ?? this.status,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      recognizedText: recognizedText ?? this.recognizedText,
      errorMessage: errorMessage,
      speechEnabled: speechEnabled ?? this.speechEnabled,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentQuestion,
        recognizedText,
        errorMessage,
        speechEnabled,
      ];

  factory ChatsState.initial() {
    return const ChatsState(status: ChatsStatus.initial);
  }
}
