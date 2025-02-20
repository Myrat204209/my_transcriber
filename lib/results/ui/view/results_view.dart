import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ResultsView extends StatelessWidget {
  const ResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readConversation(),
      builder: (context, snapshot) {
        return Column();
      },
    );
  }
}

Future<String> readConversation() async {
  try {
    final file = await _localFile;

    // Read the file
    final contents = await file.readAsString();

    return contents;
  } catch (e) {
    // If encountering an error, return 0
    return '';
  }
}
  Future<String> get _localPath async {
    final directory = await getDownloadsDirectory();

    return '${directory!.path}/Transcriber';
  }
  Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}