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
      footers: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            material.IconButton(
              icon: Icon(Icons.play_circle, color: Colors.green, size: 60),
              autofocus: true,
              onPressed: () {
                context.read<ChatsBloc>().add(
                  ChatsStarted(questionList: [...questionsList]),
                );
              },
            ),
            material.IconButton(
              icon: Icon(Icons.stop_circle, color: Colors.green, size: 40),
              autofocus: true,
              onPressed: () {},
            ),
          ],
        ),
      ],
      child: ChatsContent(),
    );
  }
}
