// import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:my_transcriber/questions/questions.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/material.dart' as material;

class QuestionsContent extends StatefulWidget {
  const QuestionsContent({super.key});

  @override
  State<QuestionsContent> createState() => _QuestionsContentState();
}

class _QuestionsContentState extends State<QuestionsContent> {
  // final List<bool> _editingStates = [];
  final List<FocusNode> _focusNodes = [];

  @override
  void dispose() {
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionsList = context.select(
      (QuestionsBloc bloc) => bloc.state.questions,
    );
    final names = questionsList.map((e) => SortableData<String>(e)).toList();
    return SortableLayer(
      dropCurve: Curves.easeInOut,
      lock: true,
      child: SortableDropFallback<int>(
        onAccept: (value) {
          setState(() {
            names.add(names.removeAt(value.data));
          });
        },
        child: Column(
          children: [
            for (int i = 0; i < names.length; i++)
              Sortable<String>(
                behavior: HitTestBehavior.translucent,
                key: ValueKey(i),
                ghost: null,
                // Text('Ghost: ${names[i].data}'),
                fallback: null,

                //  Text('Fallback --- '),
                data: names[i],
                // we only want user to drag the item from the handle,
                // so we disable the drag on the item itself
                enabled: false,
                onAcceptTop: (value) {
                  setState(() {
                    names.swapItem(value, i);
                  });
                },
                onAcceptBottom: (value) {
                  setState(() {
                    names.swapItem(value, i + 1);
                  });
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.gray),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: material.ListTile(
                    onTap: () => {},
                    leading: SortableDragHandle(
                      child: const Icon(Icons.drag_handle),
                    ),
                    title: Text(names[i].data),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
    //     
  // ReorderableListView.builder(
    //       buildDefaultDragHandles: true,
    //       itemCount: state.questions.length,
    //       itemBuilder: (context, index) {
    //         final question = state.questions[index];
    //         print(
    //           'Building tile for question: $question, editing: ${_editingStates[index]}',
    //         );
    //         return Padding(
    //           key: ValueKey(question.toLowerCase()),
    //           padding: const EdgeInsets.symmetric(
    //             vertical: 5,
    //             horizontal: 10,
    //           ),
    //           child: ListTile(
    //             onTap: () {
    //               setState(() {
    //                 _editingStates[index] = !_editingStates[index];
    //                 if (_editingStates[index]) {
    //                   _focusNodes[index].requestFocus();
    //                 }
    //                 print(
    //                   'Tile tapped, editing state: ${_editingStates[index]}',
    //                 );
    //               });
    //             },
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(15),
    //               side: const BorderSide(color: Colors.grey),
    //             ),
    //             title:
    //                 _editingStates[index]
    //                     ? TextField(
    //                       focusNode: _focusNodes[index],
    //                       controller: TextEditingController(text: question),
    //                       onSubmitted: (newText) {
    //                         context.read<QuestionsBloc>().add(
    //                           QuestionUpdated(index, newText),
    //                         );
    //                         setState(() {
    //                           _editingStates[index] = false;
    //                         });
    //                         _focusNodes[index].unfocus();
    //                         print('Text submitted: $newText');
    //                       },
    //                     )
    //                     : Text(question),
    //             tileColor: Colors.black38,
    //             leading: const Icon(Icons.drag_handle),
    //             trailing: IconButton(
    //               icon: const Icon(Icons.delete),
    //               onPressed:
    //                   () => context.read<QuestionsBloc>().add(
    //                     QuestionDeleted(index),
    //                   ),
    //             ),
    //           ),
    //         );
    //       },
    //       onReorder: (oldIndex, newIndex) {
    //         context.read<QuestionsBloc>().add(
    //           QuestionsReordered(oldIndex: oldIndex, newIndex: newIndex),
    //         );
    //       },
    //     );
    //   },
    // );
  // }