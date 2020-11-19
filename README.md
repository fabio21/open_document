# open_document

Used to create a folder on the user's mobile phone;
- Android stays inside documents with the name of your app;
- iOs is in your app's name files


## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.


 Android ->> config
 res -> create folder -> xml ->
 create provider_paths.xml

    <?xml version="1.0" encoding="utf-8"?>
     <paths>
       <external-path
         name="external_files"
         path="." />
     </paths>
  ------------------------------------------

  Add AndroidManifest :

      <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
      <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
      <uses-permission android:name="android.permission.INTERNET" />

    <provider
            android:name="androidx.core.content.FileProvider"
            android:authorities="com.example.open_document_example.fileprovider"
            android:exported="false"
            android:grantUriPermissions="true">
            <meta-data
                android:name="android.support.FILE_PROVIDER_PATHS"
                android:resource="@xml/provider_paths" />
        </provider>

   -------------------------------------------

   iOs config -> info.plist Add
   Create folder em Document
   
     <key>LSSupportsOpeningDocumentsInPlace</key>
        <true/>

   USED ->
  
    final name = await OpenDocument.getName(url);

    final path = await OpenDocument.getPathDocument("YOUR APP");

    var filePath = "$path/$name";

    final isCheck = await OpenDocument.checkDocument(filePath);

    if (!isCheck) {
      filePath = await downloadFile(filePath: "$filePath", url: url);
    }

    try {
     await OpenDocument.openDocument(filePath);
    } on PlatformException catch (e) {
     debugPrint("ERROR: message_${e.message} ---- detail_${e.details}");
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