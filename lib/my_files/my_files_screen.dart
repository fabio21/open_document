import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_document/my_files/components/slidable_my_file_item.dart';
import 'package:open_document/open_document.dart';
import 'package:share_plus/share_plus.dart';
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
  late List<FileSystemEntity> _list;
  late List<FileSystemEntity> _listNew;
  late List<String> lastPaths;
  late String pathFix = widget.filePath;
  late ScrollController _scrollController;
  late Future<List<FileSystemEntity>> future;

  bool isShare = false;

  @override
  void initState() {
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _list = [];
    _listNew = [];
    lastPaths = widget.lastPath ?? [];
    _scrollController = ScrollController();
    future = getDocumentPath();

    super.initState();
  }

  @override
  void dispose() {
    lastPaths.removeLast();
    isShare = false;
    CustomFileSystemEntity().clearValues();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
  }

  buildAppBar() {
    return AppBar(
      title: StyleMyFile.titleAppBar,
      centerTitle: false,
      titleSpacing: 0,
      elevation: Platform.isAndroid ? 8.0 : 0,
      actions: decision() ? [
          IconButton(
          padding: EdgeInsets.only(right: 24),
          icon: StyleMyFile.appBarShare,
          onPressed: () => openSelection(),
        ),
      ] : null,
    );
  }

 bool decision(){
    if(Platform.isWindows) return false;
    if(Platform.isLinux) return false;

    return true;
  }

  Widget body(BuildContext context) {
    return FutureBuilder<List<FileSystemEntity>>(
      future: future,
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
    _list = list;
    _listNew = _list;
    return MyFilesCore(
      widgets: createList(_listNew),
      lastPaths: lastPaths,
      scrollController: _scrollController,
      isShare: isShare,
      onClick: (key) => onClick(key),
    );
  }

  List<Widget> createList(List<FileSystemEntity> data) {
    List<Widget> widgets = [];
    for (FileSystemEntity file in data) {
      var date = file.statSync().modified;
      widgets.add(
        SlidableMyFileItem(
          onShared: onShared,
          pushScreen: pushScreen,
          isShare: isShare,
          file: file,
          date: date,
          lastPath: lastPaths.last,
          updateFilesList: updateFilesList,
        ),
      );
    }
    return widgets;
  }

  Future<List<FileSystemEntity>> getDocumentPath() async {
    var files = <FileSystemEntity>[];
    var completer = new Completer<List<FileSystemEntity>>();
    String path = await OpenDocument.getPathDocument();
    if (Platform.isWindows) {
       path = path.replaceAll("\\", "\\\\");
    }

    Directory dir = new Directory(path);
    var lister = dir.list(recursive: false);
    lister.listen(
      (file) {
        files.add(file);
        CustomFileSystemEntity().map[file] = false;
      },
      onDone: () {
        lastPaths.add(path);
        files.sort(
            (a, b) => b.statSync().modified.compareTo(a.statSync().modified));
        completer.complete(files);
      },
    );
    setState(() {});

    return completer.future;
  }

  openSelection() async {
    setState(() {
      isShare = !isShare;
      CustomFileSystemEntity().clearValues();
    });
  }

  pushScreen(String path) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MyFilesScreen(
          filePath: path,
          lastPath: lastPaths,
        ),
      ),
    );
  }

  updateFilesList() {
    setState(() {
      lastPaths.removeLast();
      future = getDocumentPath();
    });
  }

  onShared(FileSystemEntity file) {
    CustomFileSystemEntity().map[file] = !CustomFileSystemEntity().map[file]!;
    setState(() {});
  }

  onClick(key) {
    if (key == 1) {
      setState(() {
        isShare = !isShare;
      });
    } else {
      shareFiles();
    }
  }

  void shareFiles() async {
    List<String> selectedFiles = [];
    CustomFileSystemEntity().map.forEach((key, value) {
      if (value) selectedFiles.add(key.path);
    });

      try {
        if (!Platform.isWindows || Platform.isLinux)
        Share.shareFiles(selectedFiles);

      } on PlatformException catch (e) {
        debugPrint("${e.message}");
      }

  }
}
