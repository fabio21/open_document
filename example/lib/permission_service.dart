
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  final PermissionHandler _permissionHandler = PermissionHandler();

  Future<bool> _requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  /// Requests the users permission to any when the app is in use
  Future<bool> requestPermission(PermissionGroup permission, {Function onPermissionDenied}) async {
    var granted = await _requestPermission(permission);
    if (!granted) {
      onPermissionDenied();
    }
    return granted;
  }

  Future<bool> hasPermission(PermissionGroup permission) async {
    var permissionStatus = await _permissionHandler.checkPermissionStatus(permission);
    return permissionStatus == PermissionStatus.granted;
  }


}
