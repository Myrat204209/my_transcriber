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

    final itemExtent = useMemoized(() => 60.0, []);
    final tileShape = useMemoized(() => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: const BorderSide(color: Colors.grey),
    ), []);

    return ReorderableListView.builder(
      buildDefaultDragHandles: true,
      itemCount: names.length,
      itemExtent: itemExtent,
      itemBuilder: (context, index) {
        final name = names[index];
        final isActive = activeTileState.value.index == index;

        return Padding(
          key: ValueKey(name),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            focusColor: Colors.green,
            title: isActive
                ? TextField(
                    controller: activeTileState.value.controller,
                    focusNode: activeTileState.value.focusNode,
                    onSubmitted: (newText) {
                      context.read<QuestionsBloc>().add(QuestionUpdated(index, newText));
                      talker.warning('Text submitted: $newText');
                      cleanupResources();
                    },
                  )
                : Text(name, style: const TextStyle(fontSize: 20)),
            leading: const Icon(Icons.drag_handle),
            onTap: () {
              talker.warning('Tile tapped, index: $index');
              if (activeTileState.value.index != null && activeTileState.value.index != index) {
                cleanupResources();
              }
              activeTileState.value = ActiveTileState(
                index: index,
                focusNode: FocusNode()..requestFocus(),
                controller: TextEditingController(text: name),
              );
              talker.warning(
                'Focus State : HasFocus ${activeTileState.value.focusNode?.hasFocus}, HasPrimary : ${activeTileState.value.focusNode?.hasPrimaryFocus}',
              );
            },
            shape: tileShape,
            tileColor: Colors.black38,
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => context.read<QuestionsBloc>().add(QuestionDeleted(index)),
            ),
          ),
        );
      },
      onReorder: (oldIndex, newIndex) {
        talker.warning('Reordering questions...oldIndex: $oldIndex, newIndex: $newIndex');
        context.read<QuestionsBloc>().add(QuestionsReordered(oldIndex: oldIndex, newIndex: newIndex));
        cleanupResources();
      },
    );
  }
}
