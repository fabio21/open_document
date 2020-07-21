import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_document/open_document.dart';
import 'package:open_document_example/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initCheckPermission();
    initPlatformState();
  }

  void initCheckPermission() async {
    final _handler = PermissionsService();
    await _handler.requestPermission(PermissionGroup.storage,
        onPermissionDenied: () => setState(() => debugPrint("")));
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String filePath;

    //
    // Platform messages may fail, so we use a try/catch PlatformException.
    // "https://file-examples-com.github.io/uploads/2017/02/file_example_XLS_5000.xls";
    final url =  "https://file-examples-com.github.io/uploads/2017/10/file-example_PDF_500_kB.pdf";
    //"https://file-examples-com.github.io/uploads/2017/02/file_example_XLS_5000.xls";
      //  "https://file-examples-com.github.io/uploads/2017/02/zip_10MB.zip";
//
    final name = await OpenDocument.getName(url);
    debugPrint("Name:$name");

    final path = await OpenDocument.getPathDocument("Julia");
    filePath = "$path/$name";
//    debugPrint("Path:$filePath ->> ${await OpenDocument.checkDocument(path)}");

    final isCheck = await OpenDocument.checkDocument(filePath);
    debugPrint("Exist: $isCheck");
    try {
      if (!isCheck) {
        filePath = await downloadFile(filePath: "$filePath", url: url);
      }
      await OpenDocument.openDocument(filePath);
      //filePath = isCheck.toString();
    } on PlatformException catch (e) {
      debugPrint("ERROR: message_${e.message} ---- detail_${e.details}");
      filePath = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    setState(() {
      _platformVersion = filePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }

  Future<String> downloadFile({String filePath, String url}) async {
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
}
