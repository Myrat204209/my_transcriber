import 'package:flutter/material.dart';
import 'package:my_transcriber/questions/questions.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

class QuestionsPage extends StatelessWidget {
  const QuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Questions').bold().xLarge(),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: QuestionView(),
      floatingActionButton: const QuestionsAddButton(),
    );
  }
}
