// import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_transcriber/questions/questions.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class QuestionsContent extends StatelessWidget {
  const QuestionsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SortableData<String>> names =
        context
            .select((QuestionsBloc bloc) => bloc.state.questions)
            .map((e) => SortableData<String>(e))
            .toList();
    return QuestionsSortableShadcn(names: names);
  }
}