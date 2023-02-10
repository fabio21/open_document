
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'open_document_method_channel.dart';

abstract class OpenDocumentPlatform extends PlatformInterface {
  /// Constructs a OpenDocumentPlatform.
  OpenDocumentPlatform() : super(token: _token);

  static final Object _token = Object();

  static OpenDocumentPlatform _instance = MethodChannelOpenDocument();

  /// The default instance of [OpenDocumentPlatform] to use.
  ///
  /// Defaults to [MethodChannelOpenDocument].
  static OpenDocumentPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OpenDocumentPlatform] when
  /// they register themselves.
  static set instance(OpenDocumentPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  initialize(){
    throw UnimplementedError('inicilaze has not been implemented.');
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  ///open document [filePath]
  Future<void> openDocument({required String filePath}) async {
    throw UnimplementedError('openDocument has not been implemented.');
  }
  ///take path from folder [folderName]
  ///return path
  Future<String> getPathDocument() async {
    throw UnimplementedError('getPathDocument has not been implemented.');
  }
  ///takes folder name as app name for Android and iOS
  /// for Windows pass the name in the param[folderName]
  Future<String> getNameFolder() async {
    throw UnimplementedError('getPathDocument has not been implemented.');
  }
  ///get the url name
  Future<String> getNameFile({required String url}) async {
    throw UnimplementedError('getNameFile has not been implemented.');
  }
  /// check if the path already exists in document folder [filePath]
  Future<bool> checkDocument({required String filePath}) async {
    throw UnimplementedError('checkDocument has not been implemented.');
  }
}
