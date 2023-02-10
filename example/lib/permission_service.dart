
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {

  Future<bool> _requestPermission(Permission permission) async {
    await permission.request();
    var result = await permission.status;
    if(result.isDenied){
      Permission.storage.isGranted;
    }
    return result.isGranted;
  }

  /// Requests the users permission to any when the app is in use
  Future<bool> requestPermission(Permission permission, {required Function onPermissionDenied}) async {
    var granted = await _requestPermission(permission);
    if (!granted) {
      onPermissionDenied();
    }
    return granted;
  }

  Future<bool> hasPermission(Permission permission) async {
    var permissionStatus = await permission.status;
    return permissionStatus == PermissionStatus.granted;
  }


}
