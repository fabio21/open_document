import 'package:flutter/material.dart';
import 'package:open_document/my_files/init.dart';

class HeaderMyFolderFile extends StatelessWidget {
  final ScrollController scrollController;
  final List<String> lastPaths;

  const HeaderMyFolderFile({
    Key? key,
    required this.scrollController,
    required this.lastPaths,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(horizontal: 14),
      height: StyleMyFile.heightHeader,
      color: StyleMyFile.backgroundHeader,
      child: buildListView(),
    );
  }

  ListView buildListView() {
     final char = Platform.isWindows ? "\\" : "/";
    return ListView.separated(
      controller: scrollController,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: lastPaths.length,
      itemBuilder: (BuildContext context, int index) {
        String path = lastPaths[index].split(char).last;
        return buildContainer(path, index);
      },
      separatorBuilder: (_, __) => buildContainerSeparator(),
    );
  }

  Container buildContainerSeparator() {
    return Container(
      alignment: Alignment.center,
      child: Icon(
        Icons.chevron_right,
        color: (StyleMyFile.textColorHeader).withOpacity(0.55),
      ),
    );
  }

  Container buildContainer(String path, int index) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        path,
        style: TextStyle(
            fontSize: 14,
            color: (index == (lastPaths.length - 1))
                ? (StyleMyFile.textColorHeader)
                : (StyleMyFile.textColorHeader).withOpacity(0.75)),
        textAlign: TextAlign.center,
      ),
    );
  }
}