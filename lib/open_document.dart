import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_document/windows_fun.dart';

class OpenDocument {
  static const MethodChannel _channel = const MethodChannel('open_document');

  static Future<void> openDocument({required String filePath}) async {
    try {
      if (Platform.isWindows) return await openDocumentWindows(path: filePath);
      return await _channel.invokeMethod('openDocument', filePath);
    } on PlatformException catch (e) {
      throw OpenDocumentException(e.stacktrace.toString());
    }
  }

  static Future<String> getPathDocument({required String folderName}) async {
    try {
      if (Platform.isWindows)
        return await getPathFolderWindows(folder: folderName);
      return await _channel.invokeMethod('getPathDocument', folderName);
    } on PlatformException catch (e) {
      throw OpenDocumentException(e.stacktrace.toString());
    }
  }

  static Future<String> getNameFolder({String? widowsFolder}) async {
    try {
      if (Platform.isWindows) return widowsFolder ?? "";
      return await _channel.invokeMethod('getNameFolder');
    } on PlatformException catch (e) {
      throw OpenDocumentException(e.stacktrace.toString());
    }
  }

  static Future<String> getNameFile({required String url}) async {
    try {
      if (Platform.isWindows) return url.split("/").last;
      return await _channel.invokeMethod('getName', url);
    } on PlatformException catch (e) {
      throw OpenDocumentException(e.stacktrace.toString());
    }
  }

  static Future<bool> checkDocument({required String filePath}) async {
    try {
      if (Platform.isWindows) return await hasFolderWindows(path: filePath);
      return await _channel.invokeMethod('checkDocument', filePath);
    } on PlatformException catch (e) {
      throw OpenDocumentException(e.stacktrace.toString());
    }
  }
}

class OpenDocumentException implements Exception {
  final String errorMessage;

  OpenDocumentException(this.errorMessage);
}
