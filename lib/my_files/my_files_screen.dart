import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_document/my_files/components/slidable_my_file_item.dart';
import 'package:open_document/my_files/model/style_my_file.dart';
import 'package:open_document/open_document.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

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
      actions: [
        IconButton(
          padding: EdgeInsets.only(right: 24),
          icon: StyleMyFile.appBarShare,
          onPressed: () => openSelection(),
        ),
      ],
    );
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

  Future<String> getFolderPath({String pathStr = ""}) async {
    final PathProviderWindows provider = PathProviderWindows();
    final path = await provider.getApplicationDocumentsPath();
    var str = pathStr.isEmpty ? '${path}/${widget.filePath}' : pathStr;
    final Directory _appDocDirFolder = Directory(str);
    if (await _appDocDirFolder.exists()) {
      return _appDocDirFolder.path;
    }
    final Directory _appDocDirNewFolder =
        await _appDocDirFolder.create(recursive: true);
    return _appDocDirNewFolder.path;
  }

  Future<List<FileSystemEntity>> getDocumentPath() async {
    var files = <FileSystemEntity>[];
    var completer = new Completer<List<FileSystemEntity>>();
    String path = '';
    var nameApp = await OpenDocument.getNameFolder();
    if (widget.filePath != nameApp) {
      path = widget.filePath;
    } else {
      // if (Platform.isWindows) {
      //   path = await getFolderPath();
      // } else {
        path = await OpenDocument.getPathDocument(folderName: widget.filePath);
     // }
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

  void shareFiles() {
    List<String> selectedFiles = [];
    CustomFileSystemEntity().map.forEach((key, value) {
      if (value) selectedFiles.add(key.path);
    });
    Share.shareFiles(selectedFiles);
  }

  _openWindows(String filePath) async {
    if (await canLaunch(filePath)) {
      await launch(filePath);
    } else {
      throw 'Could not launch $filePath';
    }
  }

  _getTypeArchive(String path) async {
    var type = path.split(".").last;
    try {
      String pathValue = getPathOpenDocument(type);
      Process.run(pathValue, [path]).then((ProcessResult results) {
        debugPrint(results.stdout);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String getPathOpenDocument(String type) {
    switch (type) {
      case "pptx":
      case "ppt":
        return 'C:\\Program Files\\Microsoft Office\\root\\Office16\\POWERPNT.EXE';
      case "zip":
        return 'C:\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs\\WinRAR.exe a';
      case "pdf":
        return 'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe';
      case "xls":
      case "xlsx":
        return 'C:\\Program Files\\Microsoft Office\\root\\Office16\\EXCEL.EXE';
      case "docx":
      case "doc":
        return 'C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE';
      default:
        return "";
    }
  }
}
