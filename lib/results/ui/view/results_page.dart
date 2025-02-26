import 'package:flutter/material.dart';
import 'package:my_transcriber/results/results.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Finished Conversations')),
      body: ResultsView(),
    );
  }
}
