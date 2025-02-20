import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:my_transcriber/questions/questions.dart';

class QuestionsSortableShadcn extends StatefulWidget {
  const QuestionsSortableShadcn({super.key, required this.names});
  final List<SortableData<String>> names;
  @override
  State<QuestionsSortableShadcn> createState() =>
      _QuestionsSortableShadcnState();
}

class _QuestionsSortableShadcnState extends State<QuestionsSortableShadcn> {
  late List<SortableData<String>> names;
  @override
  void initState() {
    names = [...widget.names];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SortableLayer(
      dropCurve: Curves.easeInOut,
      dropDuration: Duration.zero,
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

                data: names[i],
                enabled: true,
                onAcceptTop: (value) {
                  context.read<QuestionsBloc>().add(
                    QuestionsReordered(
                      oldIndex: names.indexOf(value),
                      newIndex: i,
                    ),
                  );
                  names.swapItem(value, i);
                  setState(() {});
                },
                onAcceptBottom: (value) {
                  context.read<QuestionsBloc>().add(
                    QuestionsReordered(
                      oldIndex: names.indexOf(value),
                      newIndex: i,
                    ),
                  );
                  names.swapItem(value, i);
                  setState(() {});
                },
                child: OutlinedContainer(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    spacing: 10,
                    children: [
                      SortableDragHandle(child: const Icon(Icons.drag_handle)),
                      SizedBox(width: 15),
                      Text(names[i].data),
                      Expanded(child: SizedBox.shrink()),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed:
                            () => context.read<QuestionsBloc>().add(
                              QuestionDeleted(i),
                            ),
                        variance: ButtonVariance.fixed,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
