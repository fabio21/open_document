import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:open_document/my_files/init.dart';

class SlidableMyFileItem extends StatelessWidget {
  final ControllerMayFiles controllerMayFiles;
  final FileSystemEntity file;
  final DateTime date;

  const SlidableMyFileItem({
    Key? key,
    required this.file,
    required this.date,
    required this.controllerMayFiles,
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
        isShare: controllerMayFiles.isShare,
        onPushScreen: (String path) => controllerMayFiles.pushScreen(path),
        onUnzipFile: controllerMayFiles.onUnzipFile,
        onOpenDocument: (String path) => controllerMayFiles.openDocument(path),
        onShared: (file) => controllerMayFiles.onShared(file),
      ),
    );
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
        .whenComplete(() => controllerMayFiles.updateFilesList());
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
