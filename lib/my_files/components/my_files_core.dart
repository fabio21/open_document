import 'package:flutter/material.dart';

import '../init.dart';

class MyFilesCore extends StatelessWidget {
  final ControllerMayFiles controllerMayFiles;
  final List<Widget> widgets;

  const MyFilesCore({
    Key? key,
    required this.widgets,
    required this.controllerMayFiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeader(),
        buildBodyList(),
        if (controllerMayFiles.isShare)
          ButtonShare(onClick: controllerMayFiles.onClick),
      ],
    );
  }

  Expanded buildBodyList() {
    return Expanded(
        child: widgets.isNotEmpty
            ? ListView(children: widgets)
            : StyleMyFile.emptyFolder);
  }

  _scrollToEnd() async {
    controllerMayFiles.scrollController
        .jumpTo(controllerMayFiles.scrollController.position.maxScrollExtent);
  }

  Widget buildHeader() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    return HeaderMyFolderFile(
      scrollController: controllerMayFiles.scrollController,
      lastPaths: controllerMayFiles.lastPaths,
    );
  }
}
