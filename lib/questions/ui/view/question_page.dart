import 'package:flutter/material.dart' ;
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:my_transcriber/questions/questions.dart';

class QuestionsPage extends StatelessWidget {
  const QuestionsPage({super.key});

  void _showAddProfileDialog(BuildContext context) {
    shadcn.showDialog(
      context: context,
      builder: (context) => const  Dialog(
        // ...dialog configuration...
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Add Profile'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions').bold().xLarge(),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: const SortableExample5(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProfileDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
