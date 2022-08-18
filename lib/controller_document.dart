import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_document/windows_fun.dart';

import 'open_document.dart';

class ControllerDocument {
  final MethodChannel methodChannel;

  ControllerDocument(this.methodChannel);

  ///open document [filePath]
  Future<void> openDocument({required String filePath}) async {
    try {
      if (Platform.isWindows) return await openDocumentWindows(path: filePath);
      return await methodChannel.invokeMethod("openDocument", filePath);
    } on PlatformException catch (e) {
      throw OpenDocumentException('openDocument: ${e.stacktrace.toString()}');
    }
  }

  ///take path from folder [folderName]
  ///return path
  Future<String> getPathDocument({required String folderName}) async {
    try {
      if (Platform.isWindows)
        return await getPathFolderWindows(folder: folderName);
      else
        return await methodChannel.invokeMethod("getPathDocument");
    } on PlatformException catch (e) {
      throw OpenDocumentException(
          'getPathDocument: ${e.stacktrace.toString()}');
    }
  }

  ///takes folder name as app name for Android and iOS
  /// for Windows pass the name in the param[widowsFolder]
  Future<String> getNameFolder({String? widowsFolder}) async {
    try {
      if (Platform.isWindows)
        return widowsFolder ?? "app_folder";
      else
        return await methodChannel.invokeMethod("getNameFolder", widowsFolder);
    } on PlatformException catch (e) {
      throw OpenDocumentException('getNameFolder: ${e.stacktrace.toString()}');
    }
  }

  ///get the url name
  Future<String> getNameFile({required String url}) async {
    try {
      if (Platform.isWindows) return url.split("/").last;
      return await methodChannel.invokeMethod("getName", url);
    } on PlatformException catch (e) {
      throw OpenDocumentException('getNameFile: ${e.stacktrace.toString()}');
    }
  }

  /// check if the path already exists in document folder [filePath]
  Future<bool> checkDocument({required String filePath}) async {
    try {
      if (Platform.isWindows) return await hasFolderWindows(path: filePath);
      return await methodChannel.invokeMethod("checkDocument", filePath);
    } on PlatformException catch (e) {
      throw OpenDocumentException('checkDocument: ${e.stacktrace.toString()}');
    }
  }
}
