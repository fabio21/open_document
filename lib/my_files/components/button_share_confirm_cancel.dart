

import 'package:flutter/material.dart';

import '../init.dart';

class ButtonShare extends StatelessWidget {
 final Function onClick;

  const ButtonShare({Key? key, required this.onClick}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: buildElevatedButton(
                    title: StyleMyFile.elevatedButtonText, index: 2),
              ),
              SizedBox(width: 10),
              Flexible(
                child: buildElevatedButton(
                    title: StyleMyFile.elevatedButtonTextCancel, index: 1),
              ),
            ],
          )),
    );
  }

  Widget buildElevatedButton({required String title, required int index}) {
    bool enable = CustomFileSystemEntity().hasSelectedFiles();
    return Container(
      alignment: (index == 2) ? Alignment.centerRight : Alignment.centerLeft,
      child: ElevatedButton(
        onPressed: () => enable ? onClick(index) : debugPrint("---disable---"),
        style: shape(enable),
        child: Text(title),
      ),
    );
  }

  ButtonStyle shape(bool enable) {
    return ElevatedButton.styleFrom(
        elevation: 8,
        backgroundColor: enable
            ? StyleMyFile.elevatedButtonEnable
            : StyleMyFile.elevatedButtonDisable,
        textStyle: buildTextStyle(enable),
        shape: StyleMyFile.elevatedButtonShape);
  }

  TextStyle buildTextStyle(bool enable) {
    return TextStyle(
      fontSize: StyleMyFile.elevatedButtonTextStyleFontSize,
      color: enable
          ? StyleMyFile.elevatedButtonTextStyleEnable
          : StyleMyFile.elevatedButtonTextStyleDisable,
    );
  }
}
