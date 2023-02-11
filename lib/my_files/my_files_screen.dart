import 'package:flutter/material.dart';

import 'init.dart';

class MyFilesScreen extends StatefulWidget {
  final String filePath;
  final List<String>? lastPath;
  final Widget? loading;
  final Widget? error;

  const MyFilesScreen({
    Key? key,
    required this.filePath,
    this.lastPath,
    this.loading,
    this.error,
  }) : super(key: key);

  @override
  _MyFilesScreenState createState() => _MyFilesScreenState();
}

class _MyFilesScreenState extends State<MyFilesScreen>
    with SingleTickerProviderStateMixin {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late ControllerMayFiles controllerMayFiles;

  @override
  void initState() {
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    if (mounted)
      controllerMayFiles = ControllerMayFiles(
        filePath: widget.filePath,
        lastPaths: widget.lastPath ?? [],
        context: context,
      );
    super.initState();
  }

  @override
  void dispose() {
    controllerMayFiles.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controllerMayFiles,
        builder: (context, snapshot) {
          return SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              appBar: buildAppBar(),
              body: body(context),
            ),
          );
        });
  }

  buildAppBar() {
    return AppBar(
      title: StyleMyFile.titleAppBar,
      centerTitle: false,
      titleSpacing: 0,
      elevation: Platform.isAndroid ? 8.0 : 0,
      actions: controllerMayFiles.decision()
          ? [
              IconButton(
                padding: EdgeInsets.only(right: 24),
                icon: StyleMyFile.appBarShare,
                onPressed: () => controllerMayFiles.openSelection(),
              ),
            ]
          : null,
    );
  }

  Widget body(BuildContext context) {
    return FutureBuilder<List<FileSystemEntity>>(
      future: controllerMayFiles.future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return loading();
          case ConnectionState.done:
            if (!snapshot.hasData)
              return widgetError(snapshot);
            else
              return myFilesCore(snapshot.data!);
        }
      },
    );
  }

  Widget loading() =>
      widget.loading ?? Center(child: CircularProgressIndicator());

  Widget widgetError(AsyncSnapshot<List<FileSystemEntity>> snapshot) =>
      widget.error ??
      Center(
        child: Text("${snapshot.error}"),
      );

  MyFilesCore myFilesCore(List<FileSystemEntity> list) {
    controllerMayFiles.updateList(list);
    return MyFilesCore(
      widgets: createList(controllerMayFiles.listNew),
      controllerMayFiles: controllerMayFiles,
    );
  }

  List<Widget> createList(List<FileSystemEntity> data) {
    List<Widget> widgets = [];
    for (FileSystemEntity file in data) {
      var date = file.statSync().modified;
      widgets.add(
        SlidableMyFileItem(
          controllerMayFiles: controllerMayFiles,
          file: file,
          date: date,
        ),
      );
    }
    return widgets;
  }
}
