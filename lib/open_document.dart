import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class OpenDocument {
  static const MethodChannel _channel =
  const MethodChannel('open_document');

  static Future<void> openDocument({required String filePath}) async {
    try {
      await _channel.invokeMethod('openDocument', filePath);
    }on PlatformException catch (e) {
      throw OpenDocumentException(e.stacktrace.toString());
    }
  }

  static Future<String> getPathDocument({required String folderName}) async {
    try {
      final String path = await _channel.invokeMethod('getPathDocument', folderName);
      return path;
    }on PlatformException catch (e) {
      throw OpenDocumentException(e.stacktrace.toString());
    }

  }

  static Future<String> getNameFolder() async {
    try {
         final String path = await _channel.invokeMethod('getNameFolder');
         return path;
    }on PlatformException catch (e) {
      throw OpenDocumentException(e.stacktrace.toString());
    }
  }

  static Future<String> getName({required String url}) async {
    try {
      if(Platform.isWindows){
       return url.split("/").last;
      }else {
        final String str = await _channel.invokeMethod('getName', url);
        return str;
      }
    } on PlatformException catch (e) {
      throw OpenDocumentException(e.stacktrace.toString());
  }
  }

  static Future<bool> checkDocument({required String filePath}) async {
    try {
      final bool str = await _channel.invokeMethod('checkDocument', filePath);
      return str;
    } on PlatformException catch (e) {
      throw OpenDocumentException(e.stacktrace.toString());
    }
  }

}




class OpenDocumentException implements Exception {
 final String errorMessage;
  OpenDocumentException(this.errorMessage);
}
