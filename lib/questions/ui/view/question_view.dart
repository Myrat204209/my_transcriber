import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_transcriber/questions/questions.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class QuestionView extends StatelessWidget {
  const QuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionsBloc, QuestionsState>(
      buildWhen: (previous, current) =>
          previous.questions.length != current.questions.length,
      builder: (context, state) {
        if (state.status == QuestionsStatus.loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.status == QuestionsStatus.failure) {
          return const Center(child: Text('Failed to load questions'));
        } else if (state.status == QuestionsStatus.success) {
          return QuestionsContent(questions: state.questions);
        } else {
          return const Center(child: Text('No questions available'));
        }
      },
    );
  }
}
