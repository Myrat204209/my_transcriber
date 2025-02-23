import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_transcriber/chats/chats.dart';
import 'package:my_transcriber/questions/questions.dart' show QuestionsBloc;
import 'package:shadcn_flutter/shadcn_flutter.dart'
    as shadcn
    show OutlinedContainer;

part 'chats_control_panel.dart';

class ChatsContent extends StatelessWidget {
  const ChatsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsBloc, ChatsState>(
      buildWhen: (previous, current) => current.status != ChatsStatus.finished,
      builder: (context, state) {
        return ListView.separated(
          itemCount: state.currentQuestionIndex,

          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                shadcn.OutlinedContainer(
                  padding: EdgeInsets.all(10),
                  backgroundColor: Colors.white,
                  child: Text(
                    state.questions[index],
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ],
            );
          },
          separatorBuilder:
              (context, index) => Wrap(
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.end,
                direction: Axis.horizontal,
                children: [
                  shadcn.OutlinedContainer(
                    padding: EdgeInsets.all(10),
                    backgroundColor: Colors.blue,
                    child: Text(
                      state.recognizedText.length == index
                          ? ''
                          : state.recognizedText[index],
                      softWrap: true,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
        );
      },
    );
  }
}
