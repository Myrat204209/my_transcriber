import 'package:flutter/material.dart';
import 'package:my_transcriber/questions/questions.dart';
// import 'package:shadcn_flutter/shadcn_flutter.dart';

class QuestionsPage extends StatelessWidget {
  const QuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Вопросы',            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24),
),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: QuestionView(),
      floatingActionButton: const QuestionsAddButton(),
    );
    
    // Scaffold(
    //   headers: [
    //     AppBar(
    //       title: const Text(
    //         'Вопросы',
    //         style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24),
    //       ),
    //     ),
    //   ],
    //   footers: [
    //     Align(
    //       alignment: Alignment.bottomRight,
    //       child: Padding(
    //         padding: const EdgeInsets.all(15.0),
    //         child: const QuestionsAddButton(),
    //       ),
    //     ),
    //   ],
    //   child: QuestionView(),
    // );
  }
}
