import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:my_transcriber/questions/questions.dart';
import 'package:talker/talker.dart' show Talker;

final talker = GetIt.I<Talker>();

class ActiveTileState {
  final int? index;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  ActiveTileState({this.index, this.focusNode, this.controller});

  ActiveTileState copyWith({
    int? index,
    FocusNode? focusNode,
    TextEditingController? controller,
  }) {
    return ActiveTileState(
      index: index ?? this.index,
      focusNode: focusNode ?? this.focusNode,
      controller: controller ?? this.controller,
    );
  }
}

class QuestionsSortableMaterial extends HookWidget {
  const QuestionsSortableMaterial({super.key, required this.names});
  final List<String> names;

  @override
  Widget build(BuildContext context) {
    final activeTileState = useState(ActiveTileState());

    final cleanupResources = useCallback(() {
      activeTileState.value.focusNode?.unfocus();
      activeTileState.value.focusNode?.dispose();
      activeTileState.value.controller?.dispose();
      activeTileState.value = ActiveTileState();
    }, []);

    return ReorderableListView.builder(
      buildDefaultDragHandles: true,
      itemCount: names.length,
      itemBuilder: (context, index) {
        final name = names[index];
        final isActive = activeTileState.value.index == index;

        return Padding(
          key: ValueKey(name),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: InkWell(
            onTap: () {
              if (activeTileState.value.index != null &&
                  activeTileState.value.index != index) {
                cleanupResources();
              }
              activeTileState.value = ActiveTileState(
                index: index,
                focusNode: FocusNode()..requestFocus(),
                controller: TextEditingController(text: name),
              );
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),

                border: Border.all(color: Colors.grey[300]!, width: 0.5),
              ),
              child: Row(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  Icon(Icons.drag_handle, size: 30),

                  Expanded(
                    child: Wrap(
                      children: [
                        isActive
                            ? TextField(
                              controller: activeTileState.value.controller,
                              focusNode: activeTileState.value.focusNode,
                              onSubmitted: (newText) {
                                context.read<QuestionsBloc>().add(
                                  QuestionUpdated(index, newText),
                                );
                                cleanupResources();
                              },
                            )
                            : Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                      ],
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed:
                        () => context.read<QuestionsBloc>().add(
                          QuestionDeleted(index),
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      onReorder: (oldIndex, newIndex) {
        
        context.read<QuestionsBloc>().add(
          QuestionsReordered(oldIndex: oldIndex, newIndex: newIndex),
        );
        cleanupResources();
      },
    );
  }
}
