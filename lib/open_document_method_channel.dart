import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'controller_document.dart';
import 'open_document_platform_interface.dart';

/// An implementation of [OpenDocumentPlatform] that uses method channels.
class MethodChannelOpenDocument extends OpenDocumentPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('open_document');
  late final ControllerDocument controller;

  MethodChannelOpenDocument() {
    controller = ControllerDocument(methodChannel);
  }

  @override
  Future<bool> checkDocument({required String filePath}) async {
    return await controller.checkDocument(filePath: filePath);
  }

  @override
  Future<String> getNameFile({required String url}) {
    return controller.getNameFile(url: url);
  }

  @override
  Future<String> getPathDocument({required String folderName}) async {
    return await controller.getPathDocument(folderName: folderName);
  }

  @override
  Future<void> openDocument({required String filePath}) async {
    return await controller.openDocument(filePath: filePath);
  }

  @override
  Future<String> getNameFolder({String? widowsFolder}) async {
    return await controller.getNameFolder(widowsFolder: widowsFolder);
  }
}
