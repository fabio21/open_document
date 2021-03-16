import 'dart:io';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';


 void extractZip({required String path, required String lastPath, required Function updateFilesList })  {
    // Read the Zip file from disk.
    try {
      final bytes = File(path).readAsBytesSync();
      final archive = ZipDecoder().decodeBytes(bytes);
      // Extract the contents of the Zip archive to disk.
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          File("$lastPath/$filename")..createSync(recursive: true)..writeAsBytesSync(data);
        } else {
          Directory("$lastPath/$filename")..create(recursive: true);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    updateFilesList();
  }


// unzipFile(String path) async {
//   final zipFile = File(path);
//   final zipFolder = zipFile.path.split('/').last.split('.').first;
//   final destinationDir = Directory("${lastPaths.last}/$zipFolder");
//   logShow("DESTINATION_FOLDER: $destinationDir");
//
//   try {
//     await ZipFile.extractToDirectory(
//         zipFile: zipFile,
//         destinationDir: destinationDir,
//         onExtracting: (zipEntry, progress) {
//           logShow('progress: ${progress.toStringAsFixed(1)}%');
//           logShow('name: ${zipEntry.name}');
//           logShow('isDirectory: ${zipEntry.isDirectory}');
//           logShow(
//               'modificationDate: ${zipEntry.modificationDate.toLocal().toIso8601String()}');
//           logShow('uncompressedSize: ${zipEntry.uncompressedSize}');
//           logShow('compressedSize: ${zipEntry.compressedSize}');
//           logShow('compressionMethod: ${zipEntry.compressionMethod}');
//           logShow('crc: ${zipEntry.crc}');
//           return ExtractOperation.extract;
//         });
//   } catch (e) {
//     logShow(e);
//   }
//   updateFilesList();
// }