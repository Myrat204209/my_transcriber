import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_transcriber/questions/questions.dart';

class QuestionsContent extends StatelessWidget {
  const QuestionsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: BlocBuilder<QuestionsBloc, QuestionsState>(
        builder: (context, state) {
          if (state.status == QuestionsStatus.loading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (state.status == QuestionsStatus.failure) {
            return const Center(child: Text('Failed to load questions'));
          } else if (state.status == QuestionsStatus.success &&
              state.questions.isEmpty) {
            return const Center(child: Text('No questions added yet'));
          }

          return ReorderableListView.builder(
            buildDefaultDragHandles: true,
            itemCount: state.questions.length,
            itemBuilder: (context, index) {
              final question = state.questions[index];
              return Padding(
                key: ValueKey(question),
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  title: Text(question),
                  tileColor: Colors.black38,
                  leading: const Icon(Icons.drag_handle),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed:
                        () => context.read<QuestionsBloc>().add(
                          QuestionDeleted(index),
                        ),
                  ),
                ),
              );
            },
            onReorder: (oldIndex, newIndex) {
              // final updatedQuestions = [...state.questions];
              // if (oldIndex < newIndex) {
              //   newIndex -= 1;
              // }
              // final String item = updatedQuestions.removeAt(oldIndex);
              // updatedQuestions.insert(newIndex, item);
              context.read<QuestionsBloc>().add(
                QuestionsReordered(oldIndex: oldIndex, newIndex: newIndex),
              );
            },
          );
        },
      ),
    );
  }
}
