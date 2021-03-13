import 'package:flutter/material.dart';
import 'package:open_document/my_files/model/style_my_file.dart';

class HeaderMyFolderFile extends StatelessWidget {
  const HeaderMyFolderFile({
    Key? key,
    required this.scrollController,
    required this.lastPaths,
  }) : super(key: key);

  final ScrollController scrollController;
  final List<String> lastPaths;


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
    return ListView.separated(
      controller: scrollController,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: lastPaths.length,
      itemBuilder: (BuildContext context, int index) {
        String path = lastPaths[index].split('/').last;
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