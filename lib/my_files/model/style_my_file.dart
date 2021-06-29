import 'package:flutter/material.dart';

class StyleMyFile {
  static final StyleMyFile _instance = StyleMyFile._internal();

  factory StyleMyFile() => _instance;

  static Widget titleAppBar = Text("Documents");

  static Icon appBarShare = Icon(
    Icons.share,
    color: Colors.white,
  );

  static String nameFolderDocumentWindows = "Julia";

  static Color backgroundHeader = Colors.blueGrey.shade500;
  static Color textColorHeader = Colors.white;
  static double heightHeader  = 50.0;

  static String snackBarSuccessfullyDeleted = 'successfully';
  static String snackBarDeletingError = 'error';
  static Color snackBarSuccessColor = Colors.black12;
  static Color snackBarErrorColor = Colors.red.shade800;


  static Widget myFileDialogAlertFolder = Text('delete folder');
  static Widget myFileDialogAlertFile = Text('delete file');
  static String textActionCancel = 'cancel';
  static String textActionDelete = 'delete';

  static Color backgroundView = Colors.white;

  static TextStyle styleTitle = TextStyle(fontSize: 14, color: Colors.black87);
  static TextStyle styleSubtitle =
      TextStyle(fontSize: 12, color: Colors.black38);

  static Widget buildNavigationIcon = Padding(
    padding: EdgeInsets.only(right: 14),
    child: Icon(
      Icons.arrow_forward_ios,
      color: Colors.black38,
      size: 16,
    ),
  );

  static Widget folder = Padding(
    padding: EdgeInsets.only(left: 14),
    child: Icon(
      Icons.folder,
      color: Colors.black38,
      size: 24,
    ),
  );

  static Widget folderZip = Padding(
    padding: EdgeInsets.only(left: 14),
    child: Icon(
      Icons.attach_file_rounded,
      color: Colors.black38,
      size: 24,
    ),
  );

  static Widget description = Padding(
    padding: EdgeInsets.only(left: 14),
    child: Icon(
      Icons.description,
      color: Colors.black38,
      size: 24,
    ),
  );

  static Widget emptyFolder = Container(
    color: Colors.white,
    child: Center(
        child: Icon(
      Icons.folder_open,
      size: 100,
      color: Colors.grey.shade400,
    )),
  );

  static IconSlideActionModel iconSlideActionModel = IconSlideActionModel(
      color: Colors.red.shade900,
      icon: Icons.delete,
      foregroundColor: Colors.white,
  );

  static OutlinedBorder elevatedButtonShape = RoundedRectangleBorder(
  borderRadius: new BorderRadius.circular(16.0),
  );

  static Color elevatedButtonEnable = Colors.blue.shade800;
  static Color elevatedButtonDisable = Colors.blue.shade800.withAlpha(90);
  static Color elevatedButtonTextStyleEnable = Colors.white;
  static Color elevatedButtonTextStyleDisable = Colors.white.withAlpha(90);
  static double elevatedButtonTextStyleFontSize = 16.0;
  static String elevatedButtonTextCancel = "Cancel";
  static String elevatedButtonText = "Share";

  static Color checkBoxBorder =  Colors.black26;
  static Color checkBoxBackground = Colors.black12;
  static Color checkBoxIconColorActive =  Colors.lightBlue;
  static Color checkBoxIconColorNotActive =  Colors.transparent;

  StyleMyFile._internal();
}

class IconSlideActionModel {
  final Color? color; // = Colors.red.shade900;
  final bool closeOnTap;
  final IconData? icon; // Icons.delete,
  final Color? foregroundColor; // Colors.white,

  IconSlideActionModel(
      {this.color, this.closeOnTap = true, this.icon, this.foregroundColor});
}
