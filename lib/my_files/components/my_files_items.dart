import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:open_document/my_files/init.dart';
import 'package:open_document/my_files/model/style_my_file.dart';

class MyFilesItems extends StatelessWidget {
  final FileSystemEntity item;
  final DateTime date;
  final bool isShare;
  final Function onPushScreen;
  final Function onUnzipFile;
  final Function onOpenDocument;
  final Function onShared;

  const MyFilesItems({
    Key? key,
    required this.item,
    required this.date,
    this.isShare = false,
    required this.onPushScreen,
    required this.onUnzipFile,
    required this.onOpenDocument,
    required this.onShared,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = item.path.split("/").last;
    bool isDirectory = item.statSync().type.toString() == 'directory';
    bool isZipFile = title.split('.').last == 'zip';
    return InkWell(
      onTap: () => actionDecision(isDirectory, isZipFile),
      child: Container(
        decoration: buildBoxDecorationLine(),
        child: Row(
          children: [
            if (isShare && !isDirectory) buildContainerRadius(),
            buildIcon(isDirectory, isZipFile),
            buildItemTitleAndSubtitle(title),
            if (isDirectory) StyleMyFile.buildNavigationIcon,
          ],
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecorationLine() {
    return BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12, width: 1),
        ),
      );
  }

  actionDecision(bool isDirectory, bool isZipFile) {
    if (isShare && !isDirectory)
     return onShared(item);
    else if (isDirectory)
     return onPushScreen(item.path);
    else if (isZipFile)
     return onUnzipFile(item.path);
    else
      return onOpenDocument(item.path);
  }

  Widget buildItemTitleAndSubtitle(String title) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
        child: RichText(
          overflow: TextOverflow.visible,
          text: TextSpan(
            style: StyleMyFile.styleTitle,
            children: [
              TextSpan(text: "$title \n"),
              TextSpan(
                  text: convertDaTeyMdAddJMS(date),
                  style: StyleMyFile.styleSubtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildIcon(bool isDirectory, bool isZipFile) {
    if(isDirectory)
      return StyleMyFile.folder;
    else if(isZipFile)
      return StyleMyFile.folderZip;
    else
    return StyleMyFile.description;
  }


  Widget buildContainerRadius() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      width: isShare ? 30 : 0,
      height: isShare ? 30 : 0,
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        right: 10,
        left: 14,
      ),
      decoration: buildBoxDecorationChecked(),
      child: buildCheckIcon(
          isChecked: CustomFileSystemEntity().map[item] ?? false),
    );
  }

  BoxDecoration buildBoxDecorationChecked() {
    return BoxDecoration(
      border: Border.all(color: Colors.black26, width: 0.5),
      color: Colors.black12,
    );
  }

  Center buildCheckIcon({bool isChecked = false}) {
    return Center(
      child: Icon(
        Icons.check,
        size: 24,
        color: isChecked ? Colors.lightBlue : Colors.transparent,
      ),
    );
  }
}


/// Ex: 06/05/2020 3:04:00 PM (en) or 05/06/2020 15:04:00 (pt-BR)
String convertDaTeyMdAddJMS(DateTime date) {
//  LocaleMyFile();
  // Intl.defaultLocale = "pt-BR";
  return DateFormat.yMd().add_jms().format(date);
}
