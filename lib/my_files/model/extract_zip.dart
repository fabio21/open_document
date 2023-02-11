import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:open_document/my_files/init.dart';

/// extrair arquivo zip local folder and create new arquivo or new folder archive
void extractZip({required String path, required Function updateFilesList}) {
  /// Read the Zip file from disk.
  try {
    final char = Platform.isWindows ? "\\" : "/";
    var nameZip = path.split(char).last;

    final bytes = File(path).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);
    var pathLast = path.replaceAll(nameZip, "");

    /// Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File("$pathLast$filename")
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory("$pathLast$filename")..create(recursive: true);
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  updateFilesList();
}
