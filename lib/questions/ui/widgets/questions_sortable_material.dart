import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';

import 'package:my_transcriber/questions/questions.dart';
import 'package:talker/talker.dart' show Talker;

final talker = GetIt.I<Talker>();

class QuestionsSortableMaterial extends HookWidget {
  const QuestionsSortableMaterial({super.key, required this.names});
  final List<String> names;

  @override
  Widget build(BuildContext context) {
    final focus = useFocusNode();
    final textController = useTextEditingController();
    return ReorderableListView.builder(
      buildDefaultDragHandles: true,
      itemCount: names.length,
      itemBuilder: (context, index) {
        final name = names[index];
        return Padding(
          key: ValueKey(name),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            focusColor: Colors.green,
            focusNode: focus,
            title:
                focus.hasFocus
                    ? TextField(
                      controller: textController..text = name,
                      onSubmitted: (newText) {
                        context.read<QuestionsBloc>().add(
                          QuestionUpdated(index, newText),
                        );
                        focus.unfocus();
                        talker.warning('Text submitted: $newText');
                      },
                    )
                    : Text(name, style: const TextStyle(fontSize: 20)),
            leading: const Icon(Icons.drag_handle),
            onTap: () {
              talker.warning('Tile tapped, index: $index');
              focus.requestFocus();
              talker.warning(
                'Focus State :HasFocus ${focus.hasFocus},  HasPrimary : ${focus.hasPrimaryFocus}',
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: Colors.grey),
            ),
            // title:
            //     ? TextField(
            //       focusNode: _focusNodes[index],
            //       controller: TextEditingController(text: question),
            //       onSubmitted: (newText) {
            //         context.read<QuestionsBloc>().add(
            //           QuestionUpdated(index, newText),
            //         );
            //         setState(() {
            //           _editingStates[index] = false;
            //         });
            //         _focusNodes[index].unfocus();
            //         print('Text submitted: $newText');
            //       },
            //     )
            // :
            // Text(name),
            tileColor: Colors.black38,
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed:
                  () =>
                      context.read<QuestionsBloc>().add(QuestionDeleted(index)),
            ),
          ),
        );
      },

      onReorder: (oldIndex, newIndex) {
        GetIt.I<Talker>().warning(
          'Reordering questions...oldIndex: $oldIndex, newIndex: $newIndex',
        );
        context.read<QuestionsBloc>().add(
          QuestionsReordered(oldIndex: oldIndex, newIndex: newIndex),
        );
      },
    );
  }
}
