import 'dart:io';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';

class ExtractZip {
  ExtractZip({required String path, required String lastPath, required Function updateFilesList }) {
    // Read the Zip file from disk.
    try {
      final bytes = File(path).readAsBytesSync();
      // Decode the Zip file
      final archive = ZipDecoder().decodeBytes(bytes);
      // Extract the contents of the Zip archive to disk.
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          File("$lastPath/$filename")
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          Directory("$lastPath/$filename")
            ..create(recursive: true);
        }
      }
      updateFilesList();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}