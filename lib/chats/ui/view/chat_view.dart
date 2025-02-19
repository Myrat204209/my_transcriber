part of 'chat_page.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final questionsList = context.select(
      (QuestionsBloc bloc) => bloc.state.questions,
    );

    return Scaffold(
      headers: [
        AppBar(title: const Text('Speech to Text using BLoC')).center(),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          // ChatInputBox()
          // ,
          // if (state.status == ChatsStatus.started)
          Card(
            borderRadius: BorderRadius.circular(10),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              "questionsList[indexQuestion++]",
            ).withPadding(padding: EdgeInsets.symmetric(vertical: 10)),
          ),

          material.Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              material.IconButton(
                icon: Icon(
                  Icons.pause_circle_filled_rounded,
                  color: Colors.green,
                  size: 40,
                ),
                autofocus: true,
                onPressed: () {},
              ),
              material.IconButton(
                icon: Icon(Icons.play_circle, color: Colors.green, size: 60),
                autofocus: true,
                onPressed: () {
                  context.read<ChatsBloc>()
                    ..add(ChatsStarted(questionList: questionsList))
                    ..add(ChatQuestioned());
                },
              ),
              material.IconButton(
                icon: Icon(Icons.stop_circle, color: Colors.green, size: 40),
                autofocus: true,
                onPressed: () {},
              ),
            ],
          ).withPadding(padding: EdgeInsets.symmetric(vertical: 20)),
        ],
      ),
    );
  }
}
