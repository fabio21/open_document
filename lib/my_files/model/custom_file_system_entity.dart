import 'dart:io';

class CustomFileSystemEntity {
  static final CustomFileSystemEntity _instance =
      CustomFileSystemEntity._internal();
  factory CustomFileSystemEntity() => _instance;

  late Map<FileSystemEntity, bool> map;

  CustomFileSystemEntity._internal() {
    map = new Map();
  }
  /// clear map file system entity
  void clearValues() {
    map.updateAll((key, value) => false);
  }
  /// value select files share
  bool hasSelectedFiles() {
    return map.values.any((element) => element == true);
  }
}
