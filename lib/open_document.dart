import 'dart:async';

import 'open_document_platform_interface.dart';

class OpenDocument {
  ///open document [filePath]
  static Future<void> openDocument({required String filePath}) async {
    return await OpenDocumentPlatform.instance.openDocument(filePath: filePath);
  }

  ///take path from folder [folderName]
  ///return path
  static Future<String> getPathDocument() async {
    return await OpenDocumentPlatform.instance.getPathDocument();
  }

  ///takes folder name as app name for Android and iOS
  /// for Windows pass the name in the param[folderName]
  static Future<String> getNameFolder({String? folderName}) async {
    return await OpenDocumentPlatform.instance.getNameFolder();
  }

  ///get the url name
  static Future<String> getNameFile({required String url}) async {
    return await OpenDocumentPlatform.instance.getNameFile(url: url);
  }

  /// check if the path already exists in document folder [filePath]
  static checkDocument({required String filePath}) {
    return OpenDocumentPlatform.instance.checkDocument(filePath: filePath);
  }
}

