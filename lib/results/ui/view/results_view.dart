import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_transcriber/results/results.dart';

class ResultsView extends StatelessWidget {
  const ResultsView({super.key});
  @override
  Widget build(BuildContext context) {
    final fileList = context.select((ResultsBloc bloc) => bloc.state.chats);
    return BlocBuilder<ResultsBloc, ResultsState>(
      builder: (context, state) {
        return ResultsContentList(files: fileList);
      },
    );
  }
}
