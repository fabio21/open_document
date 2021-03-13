import 'dart:io';

class CustomFileSystemEntity {
  static final CustomFileSystemEntity _instance = CustomFileSystemEntity._internal();
  factory CustomFileSystemEntity() => _instance;

  late Map<FileSystemEntity, bool> map;

  CustomFileSystemEntity._internal() {
    map = new Map();
  }

  void clearValues() {
    map.updateAll((key, value) => false);
  }

  bool hasSelectedFiles() {
    return map.values.any((element) => element == true);
  }
}
