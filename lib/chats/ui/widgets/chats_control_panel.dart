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
                animationController.reset();
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
                context.read<ChatsBloc>().add(ChatsFinished());
                animationController.reset();
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
                talker.debug(
                  'AnimationController Status Before: ${animationController.status}',
                );

                animationController.isDismissed
                    ? animationController.forward()
                    : animationController.reverse();
                (chatStatus == ChatsStatus.questioning)
                    ? context.read<ChatsBloc>().add(ChatsPaused())
                    : (chatStatus == ChatsStatus.pausing)
                    ? context.read<ChatsBloc>().add(ChatsResumed())
                    : context.read<ChatsBloc>().add(
                      ChatsStarted(questionList: [...questionsList]),
                    );
                talker.warning(
                  'AnimationController Status After: ${animationController.status}',
                );
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
              icon: Icon(
                Icons.stop_circle_rounded,
                color: Colors.red,
                size: 40,
              ),
              autofocus: true,
              onPressed: () => context.read<ChatsBloc>().add(ChatsFinished()),
            ),
          ],
        );
  }
}
