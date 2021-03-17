import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_document/my_files/init.dart';
import 'package:open_document/open_document.dart';
import 'package:open_document_example/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    Wakelock.enable();
    super.initState();
    if(!Platform.isWindows && !Platform.isMacOS)
    initCheckPermission();

    initPlatformState();
  }

  void initCheckPermission() async {
    final _handler = PermissionsService();
    await _handler.requestPermission(
      Permission.storage,
      onPermissionDenied: () => setState(
        () => debugPrint("Error: "),
      ),
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String filePath;

    //
    // Platform messages may fail, so we use a try/catch PlatformException.
    // "https://file-examples-com.github.io/uploads/2017/02/file_example_XLS_5000.xls";
    final url =
        "https://file-examples-com.github.io/uploads/2017/10/file-example_PDF_500_kB.pdf";
    //"https://file-examples-com.github.io/uploads/2017/02/file_example_XLS_5000.xls";
    //  "https://file-examples-com.github.io/uploads/2017/02/zip_10MB.zip";
//
    final name = await OpenDocument.getNameFile(url: url);

    final path = await OpenDocument.getPathDocument(folderName: "example");
    filePath = "$path/$name";

    final isCheck = await OpenDocument.checkDocument(filePath: filePath);

    debugPrint("Exist: $isCheck");
    try {
      if (!isCheck) {
        filePath = await downloadFile(filePath: "$filePath", url: url);
      }
      await OpenDocument.openDocument(
        filePath: filePath,
      );

    } on PlatformException catch (e) {
      debugPrint("ERROR: message_${e.message} ---- detail_${e.details}");
      filePath = 'Failed to get platform version.';
    }

    setState(() {
      _platformVersion = filePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    StyleMyFile.elevatedButtonText = "Compartilhar";
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _pushScreen(),
          child: Icon(Icons.open_in_new),
        ),
      ),
    );
  }

  Future<String> downloadFile(
      {required String filePath, required String url}) async {
    // CancelToken cancelToken = CancelToken();
    Dio dio = new Dio();
    await dio.download(
      url,
      filePath,
      onReceiveProgress: (count, total) {
        debugPrint('---Download----Rec: $count, Total: $total');
        setState(() {
          _platformVersion = ((count / total) * 100).toStringAsFixed(0) + "%";
        });
      },
    );

    return filePath;
  }

  _pushScreen() async {
    String name = await OpenDocument.getNameFolder(widowsFolder: "Julia");

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MyFilesScreen(filePath: name),
      ),
    );
  }
}
