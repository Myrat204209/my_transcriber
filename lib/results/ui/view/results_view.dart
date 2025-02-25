import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_transcriber/results/results.dart';

class ResultsView extends StatelessWidget {
  const ResultsView({super.key});
  @override
  Widget build(BuildContext context) {
    
    final txtFiles = context.select((ResultsBloc bloc) => bloc.state.chats);

    // context.select((ResultsBloc bloc) => bloc.state.chats);
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Finished Conversations')),
      body: ResultsContentList(files: txtFiles),
    );
  }
}
