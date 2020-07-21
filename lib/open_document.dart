import 'dart:async';

import 'package:flutter/services.dart';

class OpenDocument {
  static const MethodChannel _channel =
  const MethodChannel('open_document');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> openDocument(String filePath) async {
    await _channel.invokeMethod('openDocument', filePath);
  }
  static Future<String> getPathDocument(String folderName) async {
    final String path = await _channel.invokeMethod('getPathDocument', folderName);
    return path;
  }

  static Future<String> getName(String url) async {
    final String str = await _channel.invokeMethod('getName', url);
    return str;
  }

  static Future<bool> checkDocument(String filePath) async {
    final bool str = await _channel.invokeMethod('checkDocument', filePath);
    return str;
  }
}
