part of 'chat_page.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final questionList =
        context.select((QuestionsBloc bloc) => bloc.state.questions);
    return Scaffold(
      headers: [
        AppBar(
          title: const Text('Speech to Text using BLoC'),
        ).center()
      ],
      child: BlocBuilder<ChatsBloc, ChatsState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              // ChatInputBox()
              // ,
              // Flexible(
              //   child: SizedBox(),
              //   // child: ListView.separated(
              //   //   itemCount: questionsList.length,
              //   //   itemBuilder: (context, index) {
              //   //     return DecoratedBox(
              //   //       decoration: BoxDecoration(
              //   //           color: Colors.blue,
              //   //           borderRadius: BorderRadius.circular(10)),
              //   //       child: Text(questionsList[index]).withPadding(
              //   //           padding: EdgeInsets.symmetric(
              //   //               vertical: 5, horizontal: 10)),
              //   //     ).withPadding(padding: EdgeInsets.symmetric(vertical: 10));
              //   //   },
              //   //   separatorBuilder: (context, index) => const Divider(),
              //   // ),
              // ),

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
                    icon: Icon(
                      Icons.play_circle,
                      color: Colors.green,
                      size: 60,
                    ),
                    autofocus: true,
                    onPressed: () {},
                  ),
                  material.IconButton(
                    icon: Icon(
                      Icons.stop_circle,
                      color: Colors.green,
                      size: 40,
                    ),
                    autofocus: true,
                    onPressed: () {},
                  ),
                ],
              ).withPadding(padding: EdgeInsets.symmetric(vertical: 20)),
            ],
          );
        },
      ),
    );
  }
}
