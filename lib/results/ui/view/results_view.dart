import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_transcriber/chats/chats.dart';
import 'package:my_transcriber/results/results.dart';

final exporter = ExportService();

class ResultsView extends StatelessWidget {
  const ResultsView({super.key});
  @override
  Widget build(BuildContext context) {
    context.select((ResultsBloc bloc) => bloc.state.chats);
    return Scaffold(
      //TODO: Make it possible that it will fetch whenever the exported data will appear, try to turn Future into Stream
      body: BlocBuilder<ResultsBloc, ResultsState>(
        // stream: exporter.watchListOfChats(),
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.chats.length,
            itemBuilder:
                (context, index) => ListTile(
                  title: Text('${state.chats[index]}'),
                  trailing: IconButton(
                    onPressed: () {
                      exporter.deleteFile(state.chats[index]);
                    },
                    icon: Icon(Icons.delete),
                  ),
                  onTap: () => exporter.openFile(state.chats[index]),
                ),
          );
        },
      ),
    );
  }
}
