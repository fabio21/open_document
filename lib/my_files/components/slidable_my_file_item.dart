import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:open_document/my_files/model/extract_zip.dart';
import 'package:open_document/my_files/model/style_my_file.dart';
import 'package:open_document/open_document.dart';

import 'my_files_dialog.dart';
import 'my_files_items.dart';

class SlidableMyFileItem extends StatelessWidget {
  final Function onShared;
  final Function pushScreen;
  final bool isShare;
  final FileSystemEntity file;
  final DateTime date;
  final String lastPath;
  final Function updateFilesList;

  const SlidableMyFileItem({
    Key? key,
    required this.onShared,
    required this.pushScreen,
    required this.isShare,
    required this.file,
    required this.date,
    required this.lastPath,
    required this.updateFilesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDirectory = file.statSync().type.toString() == 'directory';
    return Slidable(
      key: Key(file.path),
      startActionPane: ActionPane(
        key: UniqueKey(),
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () => StyleMyFile.iconSlideActionModel.closeOnTap,
        ),
        children: [
          SlidableAction(
            backgroundColor:
                StyleMyFile.iconSlideActionModel.color ?? Color(0xFFFE4A49),
            onPressed: (_) =>
                checkDeletingFiles(context, file.path, isDirectory),
            icon: StyleMyFile.iconSlideActionModel.icon,
            foregroundColor: StyleMyFile.iconSlideActionModel.foregroundColor,
          ),
        ],
      ),
      child: MyFilesItems(
        item: file,
        date: date,
        isShare: isShare,
        onPushScreen: (String path) => pushScreen(path),
        onUnzipFile: onUnzipFile,
        onOpenDocument: (String path) => openDocument(path),
        onShared: (file) => onShared(file),
      ),
    );
  }

  onUnzipFile(String path) => extractZip(
      path: path, lastPath: lastPath, updateFilesList: () => onStateRemove());

  onStateRemove() {
    updateFilesList();
  }

  openDocument(String path) async {
    return OpenDocument.openDocument(filePath: path);
  }

  checkDeletingFiles(BuildContext context, String path, bool isDirectory) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MyFilesDialog(
          path: path,
          isDirectory: isDirectory,
          onPressed: () => onPressed(context, path, isDirectory),
        );
      },
    );
  }

  void onPressed(
    BuildContext context,
    String path,
    bool isDirectory,
  ) {
    onDeleteFile(context, path, isDirectory);
    Navigator.of(context).pop();
  }

  void onDeleteFile(BuildContext context, String path, bool isDirectory) async {
    var document = isDirectory ? Directory(path) : File(path);
    await document
        .delete(recursive: true)
        .then(
          (value) => createSnackBar(
            context,
            message: StyleMyFile.snackBarSuccessfullyDeleted,
            backgroundColor: StyleMyFile.snackBarSuccessColor,
          ),
        )
        .catchError(
          (error) => createSnackBar(
            context,
            message: StyleMyFile.snackBarDeletingError,
            backgroundColor: StyleMyFile.snackBarErrorColor,
          ),
        )
        .whenComplete(() => updateFilesList());
  }

  createSnackBar(BuildContext context,
      {required String message, required Color backgroundColor}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 5),
      ),
    );
  }
}
