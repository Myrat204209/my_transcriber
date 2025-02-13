import 'package:shadcn_flutter/shadcn_flutter.dart';

class SortableExample5 extends StatefulWidget {
  const SortableExample5({super.key});

  @override
  State<SortableExample5> createState() => _SortableExample5State();
}

class _SortableExample5State extends State<SortableExample5> {
  List<SortableData<String>> names = [
    const SortableData('James'),
    const SortableData('John'),
    const SortableData('Robert'),
    const SortableData('Michael'),
    const SortableData('William'),
  ];

  @override
  Widget build(BuildContext context) {
    return SortableLayer(
      lock: true,
      child: SortableDropFallback<String>(
        onAccept: (received) {
          setState(() {
            // Remove item matching the received value and then add it at the end.
            names.removeWhere((element) => element.data == received.data);
            names.add(received);
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: names.map((item) {
            return Sortable<String>(
              key: ValueKey(item.data),
              data: item,
              enabled: false, // dragging only via the handle
              onAcceptTop: (received) {
                setState(() {
                  final indexCurrent = names.indexOf(item);
                  final indexReceived =
                      names.indexWhere((e) => e.data == received.data);
                  if (indexCurrent != -1 && indexReceived != -1) {
                    final temp = names[indexReceived];
                    names[indexReceived] = names[indexCurrent];
                    names[indexCurrent] = temp;
                  }
                });
              },
              onAcceptBottom: (received) {
                setState(() {
                  final indexCurrent = names.indexOf(item);
                  final indexReceived =
                      names.indexWhere((e) => e.data == received.data);
                  if (indexCurrent != -1 && indexReceived != -1) {
                    final temp = names[indexReceived];
                    names[indexReceived] = names[indexCurrent];
                    names[indexCurrent] = temp;
                  }
                });
              },
              child: OutlinedContainer(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    SortableDragHandle(child: const Icon(Icons.drag_handle)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item.data)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
