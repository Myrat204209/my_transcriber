import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:my_transcriber/questions/questions.dart';

class QuestionAddButton extends StatelessWidget {
  const QuestionAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final currentQuestions =
        context.select((QuestionsBloc bloc) => bloc.state.questions);
    return PrimaryButton(
      size: ButtonSize.normal,
      shape: ButtonShape.circle,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            final TextEditingController controller = TextEditingController();
            return AlertDialog(
              title: const Text('Add Question'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'Add question you want to ask. Click save when you\'re done'),
                  const Gap(16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: TextField(
                      controller: controller,
                    ).withPadding(vertical: 16),
                  ),
                ],
              ),
              actions: [
                PrimaryButton(
                  child: const Text('Add Question'),
                  onPressed: () {
                    final question = controller.text;
                    // if (currentQuestions.contains(question)) {
                    //   showToast(
                    //     context: context,
                    //     builder: (context, overlay) {
                    //       return SurfaceCard(
                    //         child: Basic(
                    //           title:
                    //               const Text('Question has been added before'),
                    //           trailingAlignment: Alignment.center,
                    //         ),
                    //       );
                    //     },
                    //   );
                    // }
                    if (question.isNotEmpty) {
                      context
                          .read<QuestionsBloc>()
                          .add(QuestionAdded(question));
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: const Icon(
        Icons.add,
        size: 35,
      ),
    );
  }
}
