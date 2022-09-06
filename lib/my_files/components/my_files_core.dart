import 'package:flutter/material.dart';
import 'package:open_document/my_files/components/button_share_confirm_cancel.dart';
import 'package:open_document/my_files/model/style_my_file.dart';
import 'header_my_folder_file.dart';
import '../init.dart';

class MyFilesCore extends StatelessWidget {
  final List<Widget> widgets;
  final List<String> lastPaths;
  final ScrollController scrollController;
  final bool isShare;
  final Function onClick;

  const MyFilesCore({
    Key? key,
    required this.widgets,
    required this.lastPaths,
    required this.scrollController,
    this.isShare = false,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeader(),
        buildBodyList(),
        if (isShare) ButtonShare(onClick: onClick),
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
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  Widget buildHeader() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    return HeaderMyFolderFile(
        scrollController: scrollController, lastPaths: lastPaths);
  }
}
