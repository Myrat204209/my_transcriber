import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_transcriber/questions/questions.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class QuestionView extends StatelessWidget {
  const QuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionsBloc, QuestionsState>(
      builder: (context, state) {
        return QuestionsContent();
      },
    );
  }
}
