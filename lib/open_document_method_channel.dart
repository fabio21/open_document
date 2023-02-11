import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'open_document_exception.dart';
import 'open_document_platform_interface.dart';

/// An implementation of [OpenDocumentPlatform] that uses method channels.
class MethodChannelOpenDocument extends OpenDocumentPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('open_document');

  @override
  Future<bool> checkDocument({required String filePath}) async {
    try {
      if (Platform.isWindows)
        return await methodChannel
            .invokeMethod("checkDocument", {"path": filePath});
      else
        return await methodChannel.invokeMethod("checkDocument", filePath);
    } on PlatformException catch (e) {
      throw OpenDocumentException('checkDocument: ${e.stacktrace.toString()}');
    }
  }

  @override
  Future<String> getNameFile({required String url}) async {
    try {
      if (Platform.isWindows) return url.split("/").last;
      return await methodChannel.invokeMethod("getName", url);
    } on PlatformException catch (e) {
      throw OpenDocumentException('getNameFile: ${e.stacktrace.toString()}');
    }
  }

  @override
  Future<String> getPathDocument() async {
    try {
      String path = await methodChannel.invokeMethod("getPathDocument");

      return Platform.isWindows
          ? path.replaceAll("/", "\\")
          : path;
    } on PlatformException catch (e) {
      throw OpenDocumentException(
          'getPathDocument: ${e.stacktrace.toString()}');
    }
  }

  @override
  Future<void> openDocument({required String filePath}) async {
    try {
      if (Platform.isWindows)
        return await methodChannel
            .invokeMethod("openDocument", {"path": filePath});
      else
        return await methodChannel.invokeMethod("openDocument", filePath);
    } on PlatformException catch (e) {
      throw OpenDocumentException('openDocument: ${e.toString()}');
    }
  }

  @override
  Future<String> getNameFolder() async {
    try {
      return await methodChannel.invokeMethod("getNameFolder");
    } on PlatformException catch (e) {
      throw OpenDocumentException('getNameFolder: ${e.stacktrace.toString()}');
    }
  }
}
