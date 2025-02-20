import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_transcriber/questions/questions.dart';

class QuestionsSortableMaterial extends StatelessWidget {
  const QuestionsSortableMaterial({super.key, required this.names});
  final List<String> names;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      buildDefaultDragHandles: true,
      itemCount: names.length,
      itemBuilder: (context, index) {
        final name = names[index];
        return ListTile(
          key: ValueKey(name),
          title: Text(name),
          leading: const Icon(Icons.drag_handle),
          onTap: () {
            // setState(() {
            //   _editingStates[index] = !_editingStates[index];
            //   if (_editingStates[index]) {
            //     _focusNodes[index].requestFocus();
            //   }
            //   print('Tile tapped, editing state: ${_editingStates[index]}');
            // });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.grey),
            // _editingStates[index]
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
                () => context.read<QuestionsBloc>().add(QuestionDeleted(index)),
          ),
        );
      },

      onReorder: (oldIndex, newIndex) {
        context.read<QuestionsBloc>().add(
          QuestionsReordered(oldIndex: oldIndex, newIndex: newIndex),
        );
      },
    );
  }
}
