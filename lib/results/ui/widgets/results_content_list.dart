import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_transcriber/results/results.dart';

class ResultsContentList extends StatelessWidget {
  const ResultsContentList({super.key, required this.files});

  final List<FileSystemEntity> files;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => context.read<ResultsBloc>().add(ResultsListed()),
      child: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          final chat = files[index];
          final chatName = chat.toString();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.white),
              ),
              title: Text(
                chatName.substring(
                  chatName.indexOf('Chat'),
                  chatName.indexOf('.txt'),
                ),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              trailing: IconButton(
                onPressed: () async {
                  showAdaptiveDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog.adaptive(
                          content: Text(
                            'Вы уверены что хотите удалить?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          alignment: Alignment.center,
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Отмена'),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                context.read<ResultsBloc>().add(
                                  ResultsDeleteRequested(file: chat),
                                );
                                Navigator.pop(context);
                              },
                              child: Text('Удалить'),
                            ),
                          ],
                        ),
                  );
                },
                icon: Icon(Icons.delete),
              ),
              onTap:
                  () => context.read<ResultsBloc>().add(
                    ResultsOpenRequested(file: chat),
                  ),
            ),
          );
        },
      ),
    );
  }
}
