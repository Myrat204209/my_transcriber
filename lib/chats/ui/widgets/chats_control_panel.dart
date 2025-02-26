part of 'chats_content.dart';

class ChatsControlPanel extends StatelessWidget {
  const ChatsControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final chatStatus = context.select((ChatsBloc bloc) => bloc.state.status);
    final questionsList = context.select(
      (QuestionsBloc bloc) => bloc.state.questions,
    );

    return chatStatus == ChatsStatus.ending
        ? Row(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateColor.resolveWith(
                  (states) => Colors.white,
                ),
              ),
              onPressed: () {
                context
                  ..read<ChatsBloc>().add(ChatsInitialized())
                  ..read<ResultsBloc>().add(ResultsListed());
              },
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            OutlinedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateColor.resolveWith(
                  (states) => Colors.white,
                ),
              ),
              onPressed: () {
                context
                  ..read<ChatsBloc>().add(ChatsFinished())
                  ..read<ResultsBloc>().add(ResultsListed());
              },
              child: Text(
                'Save the chat',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        )
        : Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            IconButton(
              onPressed: () {
                talker.info(
                  'Chat status: $chatStatus and state: ${chatStatus.state}',
                );
                (!chatStatus.state)
                    ? context.read<ChatsBloc>().add(ChatsPaused())
                    : (chatStatus == ChatsStatus.pausing)
                    ? context.read<ChatsBloc>().add(ChatsResumed())
                    : context.read<ChatsBloc>().add(
                      ChatsStarted(questionList: [...questionsList]),
                    );
              },
              color: chatStatus.state ? Colors.green : Colors.white,

              icon: Icon(
                chatStatus.state
                    ? Icons.play_circle_rounded
                    : Icons.pause_rounded,
                size: 60,
              ),
            ),

            IconButton(
              icon: Icon(
                Icons.stop_circle_rounded,
                color: Colors.red,
                size: 50,
              ),
              autofocus: true,
              onPressed: () => context.read<ChatsBloc>().add(ChatsFinished()),
            ),
          ],
        );
  }
}
