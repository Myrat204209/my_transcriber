part of 'chats_service.dart';

class ExportService {
  Future<File> exportToStorage({
    required List<String> questions,
    required List<String> answers,
  }) async {
    _checkStoragePermissions();
    // if (!await _checkStoragePermissions()) {
    //   throw Exception('Storage permission denied');
    // }

    final dir = await _getPlatformDirectory();
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final content = _generateConversationText(questions, answers);
    final file = File('${dir.path}/conversation.txt');
    return file.writeAsString(content);
  }

  String _generateConversationText(List<String> q, List<String> a) {
    final buffer = StringBuffer();
    for (var i = 0; i < q.length; i++) {
      buffer.writeln('Q${i + 1}: ${q[i]}');
      buffer.writeln('A${i + 1}: ${a[i]}\n');
    }
    return buffer.toString();
  }

  Future<List<FileSystemEntity>> listConversationFiles() async {
    final dir = await _getPlatformDirectory();
    if (!await dir.exists()) return [];

    final files = await dir.list().toList();
    return files.where((file) {
        return file.path.endsWith('.txt') &&
            FileSystemEntity.isFileSync(file.path);
      }).toList()
      ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
  }

  Future<void> openFile(FileSystemEntity file) async {
    if (!await file.exists()) {
      throw Exception('File not found: ${file.path}');
    }

    final result = await OpenFile.open(file.path);

    if (result.type != ResultType.done) {
      throw Exception('Failed to open file: ${result.message}');
    }
  }

  Future<void> deleteFile(FileSystemEntity file) async {
    if (!await file.exists()) return;

    try {
      await file.delete();
      final dir = file.parent;
      if (await dir.list().isEmpty) {
        await dir.delete(recursive: true);
      }
    } on FileSystemException catch (e) {
      throw Exception('Deletion failed: ${e.message}');
    }
  }
}

Future<Directory> _getPlatformDirectory() async {
  if (Platform.isAndroid) {
    final downloadDir = await getExternalStorageDirectory();
    final baseDir = Directory('${downloadDir?.path}/Talkie');
    return Directory(
      '${baseDir.path}/Conversation_${_getFormattedTimestamp()}',
    );
  } else if (Platform.isIOS) {
    final docsDir = await getApplicationDocumentsDirectory();
    return Directory(
      '${docsDir.path}/Talkie/Conversation_${_getFormattedTimestamp()}',
    );
  }
  throw UnsupportedError('Unsupported platform');
}

String _getFormattedTimestamp() {
  return DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
}

Future<void> _checkStoragePermissions() async {
  await PermissionClient().askStorage();
}





    // Directory directory;
    // if (Platform.isAndroid) {
    //   directory = Directory('/storage/emulated/0/Download');
    // } else if (Platform.isIOS) {
    //   directory = await getApplicationDocumentsDirectory();
    // } else {
    //   throw UnsupportedError("Unsupported platform");
    // }
    // final file = File('${directory.path}/Conversation.txt');
    // await file.writeAsString(textConversation);