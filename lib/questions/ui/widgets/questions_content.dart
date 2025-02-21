import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_transcriber/questions/questions.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class QuestionsContent extends StatelessWidget {
  const QuestionsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionsBloc, QuestionsState>(
      bloc: context.read<QuestionsBloc>(),
      builder: (context, state) {
        return QuestionsSortableMaterial(names: state.questions);
      },
    );
  }
}
