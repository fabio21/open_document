import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_document/windows_fun.dart';

class OpenDocument {
  static const MethodChannel _channel = const MethodChannel('open_document');

  ///open document [filePath]
  static Future<void> openDocument({required String filePath}) async {
    try {
      if (Platform.isWindows) return await openDocumentWindows(path: filePath);
     return await _channel.invokeMethod('openDocument', filePath);
    } on PlatformException catch (e) {
      throw OpenDocumentException('openDocument: ${e.stacktrace.toString()}');
    }
  }
  ///take path from folder [folderName]
  ///return path
  static Future<String> getPathDocument({required String folderName}) async {
    try {
      if (Platform.isWindows)
        return await getPathFolderWindows(folder: folderName);
      return await _channel.invokeMethod('getPathDocument', folderName);
    } on PlatformException catch (e) {
      throw OpenDocumentException('getPathDocument: ${e.stacktrace.toString()}');
    }
  }
  ///takes folder name as app name for Android and iOS
  /// for Windows pass the name in the param[widowsFolder]
  static Future<String> getNameFolder({String? widowsFolder}) async {
    try {
      if (Platform.isWindows) return widowsFolder ?? "";
      return await _channel.invokeMethod('getNameFolder');
    } on PlatformException catch (e) {
      throw OpenDocumentException('getNameFolder: ${e.stacktrace.toString()}');
    }
  }
 ///get the url name
  static Future<String> getNameFile({required String url}) async {
    try {
      if (Platform.isWindows) return url.split("/").last;
      return await _channel.invokeMethod('getName', url);
    } on PlatformException catch (e) {
      throw OpenDocumentException('getNameFile: ${e.stacktrace.toString()}');
    }
  }
 /// check if the path already exists in document folder [filePath]
  static Future<bool> checkDocument({required String filePath}) async {
    try {
      if (Platform.isWindows) return await hasFolderWindows(path: filePath);
      return await _channel.invokeMethod('checkDocument', filePath);
    } on PlatformException catch (e) {
      throw OpenDocumentException('checkDocument: ${e.stacktrace.toString()}');
    }
  }
}



class OpenDocumentException implements Exception {
  final String errorMessage;
  /// Exception info
  OpenDocumentException(this.errorMessage);
}
