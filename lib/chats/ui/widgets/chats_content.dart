import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_transcriber/chats/chats.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

class ChatsContent extends StatelessWidget {
  const ChatsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsBloc, ChatsState>(
      builder: (context, state) {
        return ListView.separated(
          itemCount: state.currentQuestion.length,

          itemBuilder: (context, index) {
            return shadcn.OutlinedContainer(
              padding: EdgeInsets.all(10),
              backgroundColor: Colors.white,
              child: Text(
                state.currentQuestion[index],
                style: TextStyle(color: Colors.black),
              ),
            );
          },
          separatorBuilder:
              (context, index) => Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  shadcn.OutlinedContainer(
                    padding: EdgeInsets.all(10),
                    backgroundColor: Colors.blue,
                    child: Text(state.currentQuestion[index]),
                  ),
                ],
              ),
        );
      },
    );
  }
}
