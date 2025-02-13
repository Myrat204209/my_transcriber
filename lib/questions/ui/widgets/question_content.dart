import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_transcriber/questions/questions.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

class QuestionsContent extends StatelessWidget {
  const QuestionsContent({
    super.key,
    required this.questions,
  });

  final List<String> questions;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      buildDefaultDragHandles: true,
      itemBuilder: (context, index) {
        final question = questions[index];
        return Column(
          key: ValueKey(question),
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Text(question),
              leading: const Icon(Icons.drag_handle),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () =>
                    context.read<QuestionsBloc>().add(QuestionDeleted(index)),
              ),
            ),
            shadcn.Divider(),
          ],
        );
      },
      itemCount: questions.length,
      onReorder: (int oldIndex, int newIndex) {
        final updatedQuestions = List<String>.from(questions);
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final String item = updatedQuestions.removeAt(oldIndex);
        updatedQuestions.insert(newIndex, item);
        context.read<QuestionsBloc>().add(QuestionsReordered(updatedQuestions));
      },
    );
  }
}
