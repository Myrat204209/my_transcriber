part of 'chats_content.dart';

class ChatsControlPanel extends HookWidget {
  const ChatsControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final chatStatus = context.select((ChatsBloc bloc) => bloc.state.status);
    final questionsList = context.select(
      (QuestionsBloc bloc) => bloc.state.questions,
    );

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),

      debugLabel: 'iconAnimation',
    );

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        IconButton(
          onPressed: () {
            animationController.isCompleted
                ? animationController.reverse()
                : animationController.forward();
            // (chatStatus == ChatsStatus.listening ||
            //         chatStatus == ChatsStatus.beeping ||
            //         chatStatus == ChatsStatus.questioning)
            //     ? context.read<ChatsBloc>().add(ChatsPaused())
            //     : context.read<ChatsBloc>().add(
            //       ChatsStarted(questionList: [...questionsList]),
            //     );
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
          onPressed: () => context.read<ChatsBloc>().add(ChatsFinished()),
        ),
      ],
    );
  }
}
