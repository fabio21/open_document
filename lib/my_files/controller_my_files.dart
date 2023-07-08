import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'init.dart';

class ControllerMayFiles extends ChangeNotifier {
  final String filePath;
  final List<String> lastPaths;
  final BuildContext context;
  late List<FileSystemEntity> list;
  late List<FileSystemEntity> listNew;

  late ScrollController scrollController;
  late Future<List<FileSystemEntity>> future;

  bool isShare = false;

  ControllerMayFiles({
    required this.filePath,
    required this.lastPaths,
    required this.context,
  }) {
    list = [];
    listNew = [];
    scrollController = ScrollController();
    future = getDocumentPath();
  }

  @override
  void dispose() {
    lastPaths.removeLast();
    isShare = false;
    CustomFileSystemEntity().clearValues();
    super.dispose();
  }

  bool decision() {
    if (Platform.isWindows) return false;
    if (Platform.isLinux) return false;

    return true;
  }

  void updateList(List<FileSystemEntity> list) {
    list = list;
    listNew = list;
  }

  Future<List<FileSystemEntity>> getDocumentPath() async {
    var files = <FileSystemEntity>[];
    var completer = new Completer<List<FileSystemEntity>>();
    String path = await OpenDocument.getPathDocument();
    String nameApp = await OpenDocument.getNameFolder();

    if (filePath.split("//").last != nameApp) {
      path = filePath;
    } else {
      path = await OpenDocument.getPathDocument();
    }

    Directory dir = new Directory(path);
    var lister = dir.list(recursive: false);
    lister.listen(
      (file) {
        files.add(file);
        CustomFileSystemEntity().map[file] = false;
      },
      onDone: () {
        lastPaths.add(path);
        files.sort(
            (a, b) => b.statSync().modified.compareTo(a.statSync().modified));
        completer.complete(files);
      },
    );
    notifyListeners();

    return completer.future;
  }

  openSelection() async {
    isShare = !isShare;
    CustomFileSystemEntity().clearValues();
    notifyListeners();
  }

  pushScreen(String path) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MyFilesScreen(
          filePath: path,
          lastPath: lastPaths,
        ),
      ),
    );
  }

  updateFilesList() {
    lastPaths.removeLast();
    future = getDocumentPath();
    notifyListeners();
  }

  onShared(FileSystemEntity file) {
    CustomFileSystemEntity().map[file] = !CustomFileSystemEntity().map[file]!;
    notifyListeners();
  }

  onClick(key) {
    if (key == 1) {
      isShare = !isShare;
      notifyListeners();
    } else {
      shareFiles();
    }
  }

  void shareFiles() async {
    List<XFile> selectedFiles = [];
    CustomFileSystemEntity().map.forEach((key, value) {
      if (value) selectedFiles.add(XFile(key.path));
    });

    try {
      if (!Platform.isWindows || Platform.isLinux)
        Share.shareXFiles(selectedFiles);
    } on PlatformException catch (e) {
      debugPrint("${e.message}");
    }
  }

  openDocument(String path) async {
    return OpenDocument.openDocument(filePath: path);
  }

  onUnzipFile(String path) =>
      extractZip(path: path, updateFilesList: () => updateFilesList());
}

/// Ex: 06/05/2020 3:04:00 PM (en) or 05/06/2020 15:04:00 (pt-BR)
String convertDaTeyMdAddJMS(DateTime date) {
  return DateFormat.yMd().add_jms().format(date);
}
