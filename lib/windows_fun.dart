import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider_windows/path_provider_windows.dart';

Future<String> getPathFolderWindows({required String folder}) async {
  final PathProviderWindows provider = PathProviderWindows();
  final path = await provider.getApplicationDocumentsPath();

  var str = '$path/$folder';

  final Directory _appDocDirFolder = Directory(str);
  if (await _appDocDirFolder.exists()) {
    return _appDocDirFolder.path;
  }
  final Directory _appDocDirNewFolder =
      await _appDocDirFolder.create(recursive: true);
  return _appDocDirNewFolder.path;
}

Future<bool> hasFolderWindows({required String path}) async {
  final Directory _appDocDirFolder = Directory(path);
  return await _appDocDirFolder.exists();
}

openDocumentWindows({required String path}) async {
  var type = path.split(".").last;
  try {
    String pathValue = await getPathOpenDocument(type: type);
    Process.run(pathValue, [path]).then((ProcessResult results) {
      debugPrint(results.stdout);
    });
  } catch (e) {
    throw e;
  }
}

Future<String> getPathOpenDocument({required String type}) async {
  switch (type) {
    case "pptx":
    case "ppt":
      return pathPpt();
    case "zip":
      return pathWinRaR();
    case "pdf":
      return await pathWeb();
    case "xls":
    case "xlsx":
      return pathExcel();
    case "docx":
    case "doc":
      return pathDoc();
    default:
      return "";
  }
}

String pathDoc() =>
    'C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE';

String pathExcel() =>
    'C:\\Program Files\\Microsoft Office\\root\\Office16\\EXCEL.EXE';

Future<String> pathWeb() async {
  String chrome = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';
  String edge =
      'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe';
  try {
    if (await hasFolderWindows(path: chrome)) {
      return chrome;
    }
    return edge;
  } catch (e) {
    throw e;
  }
}

String pathWinRaR() =>
    'C:\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs\\WinRAR.exe a';

String pathPpt() =>
    'C:\\Program Files\\Microsoft Office\\root\\Office16\\POWERPNT.EXE';
