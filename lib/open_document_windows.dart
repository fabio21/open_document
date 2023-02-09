import 'dart:io';
import 'package:path_provider_windows/path_provider_windows.dart';


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
}