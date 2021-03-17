# open_document

Used to create a folder on the user's mobile phone and Desktop;

- Android stays inside documents with the name of your app
- iOs is in your app's name files
- Windows Documents

---
## Opening pdf, xlsx, docs, ppt and zip files
---

## Getting Started


***Android ->> config res -> create folder -> xml -> create provider_paths.xml***

    <?xml version="1.0" encoding="utf-8"?>
     <paths>
       <external-path
         name="external_files"
         path="." />
     </paths>

---

***Add AndroidManifest :***

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

---

***iOs config -> info.plist Add***
Create folder em Document

     <key>LSSupportsOpeningDocumentsInPlace</key>
        <true/>

### USED ->

    final name = await OpenDocument.getNameFile(url: url);

    final path = await OpenDocument.getPathDocument(folderName: "example");

    filePath = "$path/$name";

    final isCheck = await OpenDocument.checkDocument(filePath: filePath);

    try {
      if (!isCheck) {
        filePath = await downloadFile(filePath: "$filePath", url: url);
      }

    await OpenDocument.openDocument(filePath: filePath);

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


## How to access the folder created with the files and view and delete:

With ***StyleFile*** you can change some settings
of Viewing Your Screen with Your Files

### StyleMyFile.elevatedButtonText = "Compartilhar";

***Call preview screen***

---

    pushScreen() async {
      String name = await OpenDocument.getNameFolder(widowsFolder: "Example");

        Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MyFilesScreen(filePath: name),
        ),
      );
    }

---

<img src="https://github.com/fabio21/image_readme/blob/master/view_openFile.png?raw=true"
     style="float: left; margin-right: 10px;" />