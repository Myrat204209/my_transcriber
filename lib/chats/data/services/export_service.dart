import 'dart:io';

import 'package:intl/intl.dart' show DateFormat;
import 'package:my_transcriber/permissions/permission_client.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ExportService {
  bool _isInit = false;
  Future<void> init() async {
    try {
      await _checkStoragePermissions();
      _isInit = true;
    } catch (error) {
      _isInit = false;
      throw (Exception('CheckStoragePermission error in ExportService'));
    }
  }

  Future<File> exportToStorage({
    required List<String> chatContent
  }) async {
    if (!_isInit) {
      await init();
    }

    final dir = await _getPlatformDirectory();
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final content = _generateConversationText(chatContent);
    final file = File('${dir.path}/Chat_${_getFormattedTimestamp()}.txt');
    return file.writeAsString(content);
  }

  String _generateConversationText(List<String> chat) {
    final buffer = StringBuffer();
    for (int i = 0; i < chat.length; i++) {
      buffer.writeln('${(i%2==0)? 'Q':'A'}: ${chat[i]}\n');
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
    return Directory(baseDir.path);
  } else if (Platform.isIOS) {
    final docsDir = await getApplicationDocumentsDirectory();
    return Directory('${docsDir.path}/Talkie');
  }
  throw UnsupportedError('Unsupported platform');
}

String _getFormattedTimestamp() {
  return DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
}

Future<void> _checkStoragePermissions() async {
  await PermissionClient().askStorage();
}
