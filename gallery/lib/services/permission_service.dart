import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<PermissionStatus> requestCameraPermission() async {
    final status = await Permission.camera.status;
    
    if (status.isGranted) return PermissionStatus.granted;
    
    if (status.isDenied) {
      final result = await Permission.camera.request();
      return result;
    }
    return status;
  }

  Future<PermissionStatus> requestGalleryPermission() async {
    final status = await Permission.photos.status;
    
    if (status.isGranted || status.isLimited) {
      return PermissionStatus.granted;
    }
    
    if (status.isDenied) {
      final result = await Permission.photos.request();
      if (result.isGranted || result.isLimited) {
        return PermissionStatus.granted;
      }
      return result;
    }
    return status;
  }
}