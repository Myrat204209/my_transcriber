import 'package:flutter/material.dart';
import 'package:my_transcriber/chats/chats.dart';

final exporter = ExportService();

class ResultsView extends StatelessWidget {
  const ResultsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: exporter.listConversationFiles(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder:
                  (context, index) => ListTile(
                    title: Text('${snapshot.data![index]}'),
                    trailing: IconButton(
                      onPressed: () {
                        exporter.deleteFile(snapshot.data![index]);
                      },
                      icon: Icon(Icons.delete),
                    ),
                    onTap: () => exporter.openFile(snapshot.data![index]),
                  ),
            );
          } else {
            return SizedBox(child: Text('No Data'));
          }
        },
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   spacing: 10,
        //   children: [],
        // ),
      ),
    );
  }
}
