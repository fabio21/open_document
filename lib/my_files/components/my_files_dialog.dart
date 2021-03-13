import 'package:flutter/material.dart';
import 'package:open_document/my_files/init.dart';
import 'alert_customized_for_decisions.dart';

class MyFilesDialog extends StatelessWidget {
  final String path;
  final bool isDirectory;
  final Function onPressed;

  const MyFilesDialog({
    Key? key,
    required this.path,
    required this.isDirectory,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertCustomizedForDecisions(
      alertContent: getAlertContent(context),
      actions: buildActions(context),
    );
  }

  Widget getAlertContent(context) {
    return isDirectory
        ? StyleMyFile.myFileDialogAlertFolder
        : StyleMyFile.myFileDialogAlertFile;
  }

  List<Widget> buildActions(context) {
    List<Widget> actions = [];
    actions.add(createActionButton(context, StyleMyFile.textActionCancel));
    actions.add(createActionButton(
      context,
      StyleMyFile.textActionDelete,
      onDeleteFile: () => onPressed(),
    ));
    return actions;
  }

  Widget createActionButton(context, String buttonText,
      {Function? onDeleteFile}) {
    return TextButton(
      child: Text(buttonText),
      onPressed: () =>
          onDeleteFile != null ? onDeleteFile() : Navigator.of(context).pop(),
    );
  }
}
