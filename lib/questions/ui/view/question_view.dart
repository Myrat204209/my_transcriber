import 'package:my_transcriber/questions/questions.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class QuestionsView extends StatelessWidget {
  const QuestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Gap(20),
        Expanded(
          child: ListView.separated(
            itemCount: 100,
            itemBuilder: (context, index) {
              return Text('Question $index')
                  .withPadding(vertical: 10, horizontal: 16);
            },
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
        Gap(20),
        const QuestionAddButton(),
      ],
    );
  }
}
