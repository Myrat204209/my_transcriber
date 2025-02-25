// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_transcriber/results/results.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart'
    as shadcn
    show OutlinedContainer;

import 'package:my_transcriber/chats/chats.dart';
import 'package:my_transcriber/questions/questions.dart' show QuestionsBloc;

part 'chats_control_panel.dart';

class ChatsContent extends StatelessWidget {
  const ChatsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsBloc, ChatsState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.currentQuestionIndex + state.recognizedText.length,

          itemBuilder: (context, index) {
            if (index % 2 != 0) {
              return ChatsUserSpeech(text: state.recognizedText[index ~/ 2]);
            } else {
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: shadcn.OutlinedContainer(
                  borderRadius: BorderRadius.circular(20),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  backgroundColor: Colors.white,
                  child: Text(
                    state.questions[index ~/ 2],
                    softWrap: true,

                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}

class ChatsUserSpeech extends StatelessWidget {
  const ChatsUserSpeech({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      children: [
        shadcn.OutlinedContainer(
          padding: EdgeInsets.all(10),
          backgroundColor: Colors.blue,
          child: Text(text, softWrap: true, style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
