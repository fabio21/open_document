import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertCustomizedForDecisions extends StatelessWidget {
  final Widget alertContent;
  final List<Widget> actions;

  const AlertCustomizedForDecisions({
    Key? key,
    required this.alertContent,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (Theme.of(context).platform == TargetPlatform.iOS)
        ? createIosAlertDialog()
        : createAndroidAlertDialog();
  }

  CupertinoAlertDialog createIosAlertDialog() {
    return CupertinoAlertDialog(
      content: alertContent,
      actions: actions,
    );
  }

  AlertDialog createAndroidAlertDialog() {
    return AlertDialog(
      content: alertContent,
      actions: actions,
    );
  }
}
