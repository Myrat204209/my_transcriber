part of 'chats_page.dart';

class ChatView extends HookWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    // final chatStatus = context.select((ChatsBloc bloc) => bloc.state.status);
    // // final iconAnimation = useAnimation(animation);
    // final questionsList = context.select(
    //   (QuestionsBloc bloc) => bloc.state.questions,
    // );

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),

      debugLabel: 'iconAnimation',
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text using BLoC'),
        centerTitle: true,
      ),

      bottomNavigationBar: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          IconButton(
            onPressed: () {
              animationController.isCompleted
                  ? animationController.reverse()
                  : animationController.forward();
            },
            icon: AnimatedBuilder(
              animation: animationController,
              builder:
                  (context, child) => AnimatedIcon(
                    progress: animationController,
                    color:
                        Color.lerp(
                          Colors.green,
                          Colors.white,
                          animationController.value,
                        )!,
                    icon: AnimatedIcons.play_pause,
                    size: 60,
                  ),
            ),
          ),

          IconButton(
            icon: Icon(Icons.stop_circle_rounded, color: Colors.red, size: 40),
            autofocus: true,
            onPressed: () {},
          ),
        ],
      ),

      body: ChatsContent(),
    );
  }
}
          // IconButton(
          //   icon:
          //       (chatStatus == ChatsStatus.listening ||
          //               chatStatus == ChatsStatus.beeping ||
          //               chatStatus == ChatsStatus.questioning)
          //           ? Icon(Icons.pause_circle, color: Colors.white, size: 60)
          //           : Icon(Icons.play_circle, color: Colors.green, size: 60),
          //   autofocus: true,
          //   onPressed: () {
          //     // TODO: Add functionality to pause
          //     (chatStatus == ChatsStatus.listening ||
          //             chatStatus == ChatsStatus.beeping ||
          //             chatStatus == ChatsStatus.questioning)
          //         ? context.read<ChatsBloc>().add(ChatsPaused())
          //         : context.read<ChatsBloc>().add(
          //           ChatsStarted(questionList: [...questionsList]),
          //         );
          //   },
          // ),