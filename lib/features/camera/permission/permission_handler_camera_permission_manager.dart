import 'package:permission_handler/permission_handler.dart';

import 'camera_permission_manager.dart';

/// [CameraPermissionManager] implementation backed by `permission_handler`.
class PermissionHandlerCameraPermissionManager implements CameraPermissionManager {
  @override
  Future<CameraPermissionState> checkStatus() async {
    return _map(await Permission.camera.status);
  }

  @override
  Future<CameraPermissionState> request() async {
    return _map(await Permission.camera.request());
  }

  CameraPermissionState _map(PermissionStatus status) {
    return switch (status) {
      PermissionStatus.granted || PermissionStatus.limited || PermissionStatus.provisional =>
        CameraPermissionState.granted,
      PermissionStatus.permanentlyDenied => CameraPermissionState.permanentlyDenied,
      PermissionStatus.restricted => CameraPermissionState.restricted,
      PermissionStatus.denied => CameraPermissionState.denied,
    };
  }
}
