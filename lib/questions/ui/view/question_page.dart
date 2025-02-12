import 'package:my_transcriber/questions/questions.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class QuestionsPage extends StatelessWidget {
  const QuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      headers: [
        AppBar(
          backgroundColor: Colors.green,
          title: const Text('Questions'),
          alignment: Alignment.center,
        ),
        Divider()
      ],
      child: const QuestionsView(),
    );
  }
}
