import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'open_document_exception.dart';

class WindowsFun {
  WindowsFun._();
  /// for Windows pass the name in the param[folder]
  static Future<String> getPathFolderWindows({required String folder}) async {
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

  /// check if the path already exists in document folder [path]
  static Future<bool> hasFolderWindows({required String path}) async {
    final Directory _appDocDirFolder = Directory(path);
    return await _appDocDirFolder.exists();
  }

  ///open document [path]
 static openDocumentWindows({required String path}) async {
    var type = path
        .split(".")
        .last;
    try {
      String pathValue = await _getPathOpenDocument(type: type);
      Process.run(pathValue, [path]).then((ProcessResult results) {
        debugPrint(results.stdout);
      });
    } catch (e) {
      throw OpenDocumentException("openDocumentWindows: ${e.toString()}");
    }
  }

  ///private get the path to open the file
 static Future<String> _getPathOpenDocument({required String type}) async {
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

  /// path word
 static String pathDoc() =>
      'C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE';

  /// path Excel
 static String pathExcel() =>
      'C:\\Program Files\\Microsoft Office\\root\\Office16\\EXCEL.EXE';

  /// path web chrome and edge
 static Future<String> pathWeb() async {
    String chrome = 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe';
    String edge =
        'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe';
    try {
      if (await hasFolderWindows(path: chrome)) {
        return chrome;
      }
      return edge;
    } catch (e) {
      throw OpenDocumentException("pathWeb: ${e.toString()}");
    }
  }

  /// path winrar
 static String pathWinRaR() =>
      'C:\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs\\WinRAR.exe a';

  /// path PowerPoint
 static String pathPpt() =>
      'C:\\Program Files\\Microsoft Office\\root\\Office16\\POWERPNT.EXE';

}